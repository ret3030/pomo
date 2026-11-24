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
