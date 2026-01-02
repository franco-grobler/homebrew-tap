class CowsayCli < Formula
  desc "Command-line interface for cowsay-rs"
  homepage "https://franco-grobler.github.io/cowsay-rs/"
  version "0.3.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.24/cowsay-cli-aarch64-apple-darwin.tar.gz"
      sha256 "58cfec2ed47d7d8cdd0d600c19983a5bd378238423c06a48a8761b14360db29a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.24/cowsay-cli-x86_64-apple-darwin.tar.gz"
      sha256 "63205c65b0af1c381d7b1fbec437f5ab05482e8532c0f644d43067a1994a4f47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.24/cowsay-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "23f075bca8911e88d33af7ea0e9a1ea00d0ba1666163f4dfcb6779a8fb11df1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.24/cowsay-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "571acd6a277b1c9c60e5546343d76bc78af28e522a7ed67ffd92a8301e566012"
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
