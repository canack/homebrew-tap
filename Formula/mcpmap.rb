class Mcpmap < Formula
  desc "Discover MCP (Model Context Protocol) servers on network ranges"
  homepage "https://github.com/canack/mcpmap"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.0/mcpmap-aarch64-apple-darwin.tar.xz"
      sha256 "feac06cc9f857df22f21cf131d151a8bcf5f56a68d28c44501efdf858df1c7da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.0/mcpmap-x86_64-apple-darwin.tar.xz"
      sha256 "cd7f34e4d9f56e6f6e1007c4a50c2fbf6f03698eb68554ab4c8e940cf9375199"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.0/mcpmap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98fc1d238ea9b37b306ea2ad0a0b743641139fbae046d4cf82fab4918b202518"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.0/mcpmap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "deb971ac70c5f3a7888132f371af5665e63bc02fbff71eeb420fa91b2b48dc92"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "mcpmap" if OS.mac? && Hardware::CPU.arm?
    bin.install "mcpmap" if OS.mac? && Hardware::CPU.intel?
    bin.install "mcpmap" if OS.linux? && Hardware::CPU.arm?
    bin.install "mcpmap" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
