# TODO

- Universal binary (arm64 and x86_64) if Pomo should run on Intel Macs. Without Xcode this means two builds joined with `lipo`.
- GitHub Action that bumps `version` and `sha256` in ret3030/homebrew-tap after each release.
- Optional: Apple Developer account (99 USD per year), Developer ID signing and notarization. Then the cask no longer needs to clear the quarantine flag and Pomo could go into the official `homebrew/cask`.
