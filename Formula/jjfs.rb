class Jjfs < Formula
  desc "Eventually consistent multi-mount filesystem using Jujutsu"
  homepage "https://github.com/jtippett/jjfs"
  version "0.1.0"
  url "https://github.com/jtippett/jjfs.git",
      revision: "1ebab323b50b2a29c4611bf44a27195d1af302df"
  license "MIT"

  depends_on "crystal"
  depends_on "jj"

  on_macos do
    depends_on "fswatch"
  end

  on_linux do
    depends_on "bindfs"
  end

  def install
    # Create bin directory for build
    mkdir_p "bin"

    # Build both binaries
    system "crystal", "build", "src/jjfs.cr", "-o", "bin/jjfs", "--release"
    system "crystal", "build", "src/jjfsd.cr", "-o", "bin/jjfsd", "--release"

    # Install binaries
    bin.install "bin/jjfs"
    bin.install "bin/jjfsd"

    # Install templates for service installation
    prefix.install "templates"

    # Install documentation
    doc.install "README.md"
    doc.install "CHANGELOG.md"
    doc.install "docs/user-guide.md"
  end

  def post_install
    ohai "jjfs installed successfully!"
  end

  def caveats
    s = <<~EOS
      To get started:
        1. Install bindfs: brew install --cask macfuse && brew install gromgit/fuse/bindfs-mac
        2. Install the daemon service: jjfs install
        3. Initialize a repo: jjfs init
        4. Open a mount: jjfs open default

      Note: bindfs requires macFUSE to be installed separately.

      After upgrading, restart the daemon to use the new version:
        jjfs stop
        jjfs start

      For more information, see:
        #{doc}/README.md
        #{doc}/user-guide.md
    EOS

    on_linux do
      s = <<~EOS
        To get started:
          1. Install the daemon service: jjfs install
          2. Initialize a repo: jjfs init
          3. Open a mount: jjfs open default

        For more information, see:
          #{doc}/README.md
          #{doc}/user-guide.md
      EOS
    end

    s
  end

  test do
    # Test that binaries run and show version
    assert_match "jjfs v0.1.0", shell_output("#{bin}/jjfs 2>&1")

    # Test init command (in temporary directory)
    system bin/"jjfs", "init", "test-repo"
    assert_predicate testpath/".jjfs/repos/test-repo", :exist?
    assert_predicate testpath/".jjfs/config.json", :exist?
  end
end
