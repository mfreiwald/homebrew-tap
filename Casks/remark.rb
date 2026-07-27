# Homebrew Cask for the Remark macOS app. The `remark` CLI ships INSIDE the app bundle
# (Contents/Helpers/remark-cli) for both distributions, so the cask installs the GUI and exposes the CLI
# via the `binary` stanza below — no separate CLI download. (Mac App Store users get the app from the
# Store; the in-app "Install Command-Line Tool…" menu links the CLI there.)
#
# TEMPLATE — release.yml fills in the real `version` + `sha256` (of Remark.dmg) and pushes this to the tap
# (e.g. `mfreiwald/homebrew-tap`) so `brew install --cask mfreiwald/tap/remark` works. The `url` derives
# from `version`, so only those two fields change per release.
#
# `url` points at the public R2/CDN mirror (updates.getremark.app), NOT a GitHub release: the source repo
# `mfreiwald/remark` is PRIVATE, so its release assets 404 for anonymous `brew` users. R2 already hosts
# the byte-identical DMG (same sha256) as the Sparkle update source. Don't repoint this at GitHub.
cask "remark" do
  version "2026.5.0"
  sha256 "73b7878d291cc077b8f6617d398bb7e44192d343eb01edaaf3e4281c8cfaca0b"

  url "https://updates.getremark.app/stable/#{version}/Remark.dmg"
  name "Remark"
  desc "Markdown review tool for AI-assisted workflows"
  homepage "https://getremark.app"

  depends_on macos: :sonoma # macOS 14+ (>= Sonoma), matches the app's deployment target

  app "Remark.app"
  # Expose the bundled CLI as `remark` on $PATH — the same binary the in-app installer links. Talks to the
  # running app over its localhost MCP server (HTTP), or runs `remark mcp` as a stdio proxy for stdio agents.
  binary "#{appdir}/Remark.app/Contents/Helpers/remark-cli", target: "remark"

  zap trash: [
    "~/Library/Application Support/dev.freiwald.remark",
    "~/.config/remark",
  ]

  caveats <<~EOS
    `remark` talks to the running Remark app over its localhost MCP server, so launch Remark
    (and unlock Pro) before using `remark cli …` or registering `remark mcp` with an agent.
  EOS
end
