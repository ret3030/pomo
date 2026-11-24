<p align="center">
  <img src="docs/icon.png" width="160" alt="Pomo icon">
</p>

<h1 align="center">Pomo</h1>

<p align="center">A tiny 50/10 pomodoro timer that lives in the macOS menu bar.</p>

Pomo counts down 50 minutes of focus and 10 minutes of break, over and over, until you stop it. The time stays visible in the menu bar the whole time (`🍅 49:59`, then `☕ 09:59`), and every switch comes with a notification and a soft sound. There are no settings and no windows: just Start and Stop.

The countdown follows the clock rather than counting ticks, so it stays correct after your Mac sleeps and picks up where it left off after a restart. It uses next to no CPU or memory.

## Install

```sh
brew trust --tap ret3030/tap
brew install --cask ret3030/tap/pomo
```

Pomo runs on Apple Silicon Macs with macOS 14 or newer. It is signed ad hoc, not notarized; the cask clears the quarantine flag so macOS lets it start.

## Use

Click the 🍅 in the menu bar and choose Start. The menu shows the current session, for example "Session 3: Focus". Stop ends the loop and resets the count. Turn on Launch at Login to keep Pomo in the menu bar after every restart. On first launch, allow notifications so you see when a phase ends.

## Build

Building needs the Xcode Command Line Tools (`xcode-select --install`). Xcode itself is not needed.

```sh
scripts/build.sh                        # builds build/Pomo.app
cp -R build/Pomo.app /Applications/
open /Applications/Pomo.app
```

Run the tests with `scripts/test.sh`. To publish a new version, raise `CFBundleShortVersionString` in `Resources/Info.plist`, run `scripts/release.sh`, and put the printed `version` and `sha256` into `Casks/pomo.rb` in [ret3030/homebrew-tap](https://github.com/ret3030/homebrew-tap). `scripts/make-icon.sh` regenerates the icon, and `pomo.sh` is the original terminal version that Pomo grew out of.
