class Jjfs < Formula
  desc "Eventually consistent multi-mount filesystem using Jujutsu"
  homepage "https://github.com/yourusername/jjfs"
  url "https://github.com/yourusername/jjfs/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "57e1941ef9d4e42ddb6a8919509baf990a299da27b321b7829c65b07c2648eb2"
  license "MIT"

  depends_on "crystal"
  depends_on "jj"
  depends_on "bindfs"
  depends_on "fswatch"

  def install
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
    # Inform user about setup
    ohai "jjfs installed successfully!"
    puts <<~EOS
      To get started:
        1. Install the daemon service: jjfs install
        2. Initialize a repo: jjfs init
        3. Open a mount: jjfs open default

      For more information, see:
        #{doc}/README.md
        #{doc}/user-guide.md
    EOS
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
