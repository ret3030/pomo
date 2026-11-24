# TODO

Turn `pomo.sh` into a native macOS menu bar app that is easy to install.

## App

1. Swift app with `NSStatusItem`: the menu bar shows 🍅 when idle, `🍅 49:59` during work and `☕ 09:59` during a break.
2. Menu with Start and Stop, the 50/10 loop runs on its own like in `pomo.sh`.
3. Count down from a stored end time (`endsAt`), not by counting ticks, so the timer stays correct after sleep or a restart.
4. Notification and the Glass sound at every phase change (`UNUserNotificationCenter`, needs a real bundle).
5. Settings in `UserDefaults`: work and break length (25/5, 50/10, custom).
6. Launch at login via `SMAppService.mainApp.register()`, toggled from the menu.
7. `.app` bundle with `Info.plist`, `LSUIElement = true` so there is no Dock icon, bundle id `com.ret3030.pomo`, minimum macOS 13.
8. Build script (or Xcode project) that produces `Pomo.app`, ad hoc signed with `codesign -s -`.

## Distribution

1. Package: `ditto -c -k --keepParent Pomo.app Pomo-<version>.zip`, then `shasum -a 256`.
2. Decide visibility: brew downloads release assets anonymously, so a private `pomo` repo will not work. Either make `pomo` public or publish only the zip as a release in a public repo.
3. Public tap repo `ret3030/homebrew-tap` with `Casks/pomo.rb`: `version`, `sha256`, `url` to the release zip, `app "Pomo.app"`, `zap trash: "~/Library/Preferences/com.ret3030.pomo.plist"`.
4. Without notarization Gatekeeper blocks the first launch. In our own tap, add a `postflight` step that runs `xattr -dr com.apple.quarantine` on the app. Homebrew 5 removed `--no-quarantine`, and the official `homebrew/cask` has disabled casks that fail Gatekeeper since 2026-09-01.
5. Check that the cask passes `brew audit --cask ret3030/tap/pomo` and `brew style`. Check whether Homebrew 6 really requires trusting third-party taps (only seen in project issues so far).
6. Install with `brew install --cask ret3030/tap/pomo`. Each release only bumps `version` and `sha256`, later automated with a GitHub Action.

## Later, optional

Apple Developer account (99 USD per year), Developer ID signing and notarization. Then no `postflight` workaround is needed and the app could go into the official `homebrew/cask`.
