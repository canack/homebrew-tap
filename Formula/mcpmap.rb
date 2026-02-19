class Mcpmap < Formula
  desc "Discover MCP (Model Context Protocol) servers on network ranges"
  homepage "https://github.com/canack/mcpmap"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.1/mcpmap-aarch64-apple-darwin.tar.xz"
      sha256 "362f0e3bb11e471ebc5d6fda64c30a9851fd17bca3546c9f3795fd6425516686"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.1/mcpmap-x86_64-apple-darwin.tar.xz"
      sha256 "b7c1bb4d83a4099497caa6a03c5b77b3df9b57fe5472be1157300d60bff0d7b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.1/mcpmap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3172618cf42be94b2d2a60f0e7b6e2992b39f5947a32a762595387f892f9092"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canack/mcpmap/releases/download/v0.1.1/mcpmap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "baaa81c9ff29e3c1e4319e0154d36b3262a79f084e2a61e4833ac6b7555677a6"
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
