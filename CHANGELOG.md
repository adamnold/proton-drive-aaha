# Changelog

## v1.2.1 — 2026-07-15

- Added the standard `~/.local/opt/aaha/proton-drive-aaha` default and explicit
  custom-root installation without changing AppImage execution.
- Added guarded installation receipts, identity markers, and regression tests
  for unsafe paths, mismatches, profile preservation, and purge.
- Made icon generation deterministic by removing variable PNG metadata.

## v1.2.0 — 2026-07-11

- Updated to exact Electron 43.1.0 and the AAHA v2 security, privacy, reproducible-build, icon, installer, checksum, test, and CI standard.
- Preserved safe browser upload/download behavior and Proton navigation.

## v1.1.1

- Previous stable wrapper. Superseded because its Electron runtime is unsupported.
