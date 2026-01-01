class CowsayCli < Formula
  desc "A command-line interface for cowsay-rs"
  homepage "https://franco-grobler.github.io/cowsay-rs/"
  version "0.3.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.22/cowsay-cli-aarch64-apple-darwin.tar.gz"
      sha256 "a76d1444f6ea7ff2a4a7043453d7d5088bb8f7ba1f3a0f59801c457538495a2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.22/cowsay-cli-x86_64-apple-darwin.tar.gz"
      sha256 "8220a8b2a9286b3d0598e1dca56bdb5c6308fb53f46517815336eb3096356a3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.22/cowsay-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ede0c5de4fba022fc129f30779aa345420ce8e2408b358cf2de88f000630304e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/franco-grobler/cowsay-rs/releases/download/v0.3.22/cowsay-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3c04900ef3010a6f4bfad65f0fd9aff81471866b837032154d43bf77f8badab3"
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
