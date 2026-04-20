# Upstream sync

This translation is based on the English original:

- **Repo:** https://github.com/beejjorgensen/bgnet0
- **Commit:** `713c538558d3550d3cd496ee3e7ff64fe7c17326`
- **Version:** v1.0.40 (April 18, 2025)

Update this file when syncing from a newer upstream commit. The release
workflow reads it to embed provenance in the release notes.

## Release tags

We tag translation releases as:

    v<UPSTREAM_VERSION>-vi.<N>

For example, `v1.0.40-vi.1` is the first Vietnamese release based on
upstream v1.0.40. Subsequent translation fixes against the same upstream
version bump `N` (`v1.0.40-vi.2`, `v1.0.40-vi.3`, ...). When upstream
bumps their version, we restart `N` at 1 (`v1.0.41-vi.1`).

Use `scripts/release.sh` to create and push a tag; the
`.github/workflows/release.yml` workflow then builds and publishes a
GitHub Release with all artifacts.
