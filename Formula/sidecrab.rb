class Sidecrab < Formula
  desc "Claude Code desktop pet - 8-bit crab companion that reacts to Claude working"
  homepage "https://github.com/zvoque/sidecrab"
  url "https://github.com/zvoque/sidecrab/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2fcf4cca84f32d19acf9c21539cfdd0df88d808b432efa41fb561a31b9eefee5"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos

  def install
    cd "src-tauri" do
      # hook sidecar first: the app's build script validates its presence
      system "cargo", "build", "--release", "-p", "sidecrab-hook"
      triple = Utils.safe_popen_read("rustc", "-vV")[/host: (\S+)/, 1]
      mkdir_p "binaries"
      cp "target/release/sidecrab-hook", "binaries/sidecrab-hook-#{triple}"
      system "cargo", "build", "--release"
      bin.install "target/release/sidecrab"
      bin.install "target/release/sidecrab-hook"
    end
  end

  def caveats
    <<~EOS
      Run `sidecrab` to summon him (detaches from the terminal automatically).
      Right-click the crab for settings, including "Launch at login".
    EOS
  end

  test do
    assert_predicate bin/"sidecrab-hook", :exist?
  end
end
