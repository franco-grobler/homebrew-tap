class CowsayCli < Formula
  desc "Command-line interface for cowsay-rs"
  homepage "https://franco-grobler.github.io/cowsay-rs/"
  version "0.3.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.23/cowsay-cli-aarch64-apple-darwin.tar.gz"
      sha256 "35888528c119a2ee4931ccde8407d2ebb3518d6e10c10f860eb4cefc57c45399"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.23/cowsay-cli-x86_64-apple-darwin.tar.gz"
      sha256 "0112b1bf3ab52f5b4a323bec78e06050038d053acf9884eb1ef4106bb8c54fb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.23/cowsay-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "47ca0854273256b486db5445c025d069510f5da8b9918e8b8728947fcb5e4157"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.23/cowsay-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2eeef77cc225921bc846fa6cc5c10d5d720ac8be1d695bd98f2ea26e9c680dcd"
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
