class CowsayCli < Formula
  desc "A command-line interface for cowsay-rs"
  homepage "https://franco-grobler.github.io/cowsay-rs/"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.2/cowsay-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6969ed8185378d1e9e55f9bf99d72e270ad056882d44b012bc6d586793bb4d20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.2/cowsay-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ec989399ab62fe4d2ee12996adc7f4eb789473fdbe3124cf7af15a75ab2f56cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.2/cowsay-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e3b5aa5d5bb1992dde9b5d7fa2b3165afe817fd5ed66a28783ceefdff3d9ea5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.2/cowsay-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a95360db647a9c587fb35fc9fdb39a70a6a88d9bc21711293064d04d3d646c2"
    end
  end
  license "UNLICENSE"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "cowsay-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "cowsay-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "cowsay-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "cowsay-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
