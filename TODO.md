# TODO

## App

- [x] Menu bar app with Start and Stop, looping 50/10 like `pomo.sh`.
- [x] Countdown from a stored end time, correct after sleep and restart.
- [x] Notification and the Glass sound at every phase change.
- [x] Launch at login via `SMAppService`, toggled from the menu.
- [x] `.app` bundle with `LSUIElement`, built and ad hoc signed by `scripts/build.sh`.
- [x] Session number in the menu.
- [x] App icon.

Work and break lengths stay fixed at 50/10 on purpose.

## Distribution

1. Package: `ditto -c -k --keepParent Pomo.app Pomo-<version>.zip`, then `shasum -a 256`.
2. Decide visibility: brew downloads release assets anonymously, so a private `pomo` repo will not work. Either make `pomo` public or publish only the zip as a release in a public repo.
3. Decide whether to ship a universal binary (arm64 and x86_64) for Intel Macs.
4. Public tap repo `ret3030/homebrew-tap` with `Casks/pomo.rb`: `version`, `sha256`, `url` to the release zip, `app "Pomo.app"`, `depends_on macos: ">= :sonoma"`, `zap trash: "~/Library/Preferences/com.ret3030.pomo.plist"`.
5. Without notarization Gatekeeper blocks the first launch. In our own tap, add a `postflight` step that runs `xattr -dr com.apple.quarantine` on the app. Homebrew 5 removed `--no-quarantine`, and the official `homebrew/cask` has disabled casks that fail Gatekeeper since 2026-09-01.
6. Check that the cask passes `brew audit --cask ret3030/tap/pomo` and `brew style`. Check whether Homebrew 6 really requires trusting third-party taps (only seen in project issues so far).
7. Install with `brew install --cask ret3030/tap/pomo`. Each release only bumps `version` and `sha256`, later automated with a GitHub Action.

## Later, optional

Apple Developer account (99 USD per year), Developer ID signing and notarization. Then no `postflight` workaround is needed and the app could go into the official `homebrew/cask`.
