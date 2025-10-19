class Jjfs < Formula
  desc "Eventually consistent multi-mount filesystem using Jujutsu"
  homepage "https://github.com/jtippett/jjfs"
  version "0.2.1"
  url "https://github.com/jtippett/jjfs.git",
      revision: "319dc275c2e3bb08f4a5afa5e93376c5934ca602"
  license "MIT"

  depends_on "crystal"
  depends_on "jj"

  depends_on "rust" => :build

  on_macos do
    depends_on "fswatch"
  end

  def install
    # Create bin directory for build
    mkdir_p "bin"

    # Build Rust NFS server
    cd "jjfs-nfs" do
      system "cargo", "build", "--release"
      cp "target/release/jjfs-nfs", "../bin/"
    end

    # Build Crystal binaries
    system "crystal", "build", "src/jjfs.cr", "-o", "bin/jjfs", "--release"
    system "crystal", "build", "src/jjfsd.cr", "-o", "bin/jjfsd", "--release"

    # Install binaries
    bin.install "bin/jjfs"
    bin.install "bin/jjfsd"
    bin.install "bin/jjfs-nfs"

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
    <<~EOS
      To get started:
        1. Install the daemon service: jjfs install
        2. Create a new repo: jjfs new my-notes
        3. Open a mount: jjfs open my-notes ~/Documents/notes

      Note: Mounting requires sudo password (normal macOS NFS behavior)

      After upgrading, restart the daemon to use the new version:
        jjfs stop
        jjfs start

      For more information, see:
        #{doc}/README.md
        #{doc}/user-guide.md
    EOS
  end

  test do
    # Test that binaries run and show version
    assert_match "jjfs v0.2.1", shell_output("#{bin}/jjfs 2>&1")

    # Test init command (in temporary directory)
    system bin/"jjfs", "init", "test-repo"
    assert_predicate testpath/".jjfs/repos/test-repo", :exist?
    assert_predicate testpath/".jjfs/config.json", :exist?
  end
end
