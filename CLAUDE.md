# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal collection of shell/Python scripts and systemd units for setting up and
maintaining Debian/Ubuntu desktop machines (package installs, QGIS dev environment,
Docker services, backup/sleep/VPN automation, dotfiles). There is no build system,
package manifest, or application code — everything is standalone scripts invoked
directly or sourced by the two top-level orchestrators.

## Formatting

- Shell scripts are formatted with `shfmt` (VS Code: `mkhl.shfmt`, format-on-save).
  Rules come from `.editorconfig`, which `shfmt` reads natively: 4-space indent,
  LF line endings, final newline, binary operators (`&&`/`||`) at the start of a
  continued line, indented `case` branches.
- Python is formatted with `black` (VS Code: `ms-python.black-formatter`,
  format-on-save).
- Nearly every script starts with `set -euo pipefail`; keep that when adding new
  scripts.

## Testing / CI

There is no test suite. CI (`.github/workflows/test-debian.yml`, triggered on
changes to `first_run.sh`, `complete_install.sh`, `install/**`, or
`python_programs/**`) just runs `first_run.sh` then `complete_install.sh` inside a
`debian:trixie` container to confirm the install flow doesn't error out.
`.github/workflows/test.yml` runs the same two scripts on `ubuntu-24.04` runners on
push to `ubuntu-*` branches. To sanity-check a change locally before pushing, run
the relevant `install/*.sh` script directly, or run `first_run.sh` /
`complete_install.sh` end-to-end in a throwaway container/VM — they are not
idempotent-safe to re-run carelessly against a real desktop.

## Architecture

**Two entry-point orchestrators, run once per machine:**
- `first_run.sh` — bare-metal bootstrap: installs git/zsh, clones this repo to
  `~/Codes/linux-scripts`, symlinks it to `~/Scripts`, applies zsh dotfiles from
  `settings/`, and sets a few display-manager (lightdm) tweaks.
- `complete_install.sh` — the main package install, run after `first_run.sh`. It
  `source`s a long, ordered sequence of scripts from `install/*.sh` (order matters:
  later scripts sometimes assume earlier tooling exists, e.g. GIS libs before
  QGIS). Each `install/*.sh` is self-contained and idempotent-ish (installs one
  piece of software or one apt source). New installable software should get its
  own `install/<name>.sh` and be `source`d from `complete_install.sh` in a sensible
  position, not inlined.

**`services/<name>/`** — each subfolder is a self-contained systemd deployment unit:
scripts to run + `.service` and (optionally) `.timer` unit files + an `install.sh`
that copies the script(s) to `/usr/local/bin/`, copies units to
`/etc/systemd/system/`, then `daemon-reload` + `enable --now`. Non-trivial ones
(e.g. `qgis-compile/`) document behavior/caveats in a local `README.md` — follow
that pattern for new services rather than relying on inline comments. To modify a
running service, edit the files here and re-run that service's `install.sh` (units
are not symlinked; the copy on disk must be refreshed and `daemon-reload`d).

**`qgis/`** — QGIS-specific dev workflow: building QGIS from source across multiple
git worktrees (`qgis_build_folders.sh`, driven by `cmake --workflow`), moving
worktrees, running Python tests, VS Code debug config in `qgis/vscode/`. This
overlaps conceptually with `services/qgis-compile/` (the automated nightly version
of the same build) — check both when touching QGIS build logic.

**`python_programs/util_functions.py`** — shared helpers imported by the Python
scripts in `python_programs/` (colored console output, apt source-file generation,
GPG key fetching, wget/curl wrappers that shell out with `sudo`). Assumes a
Debian/Ubuntu host with `zsh`, `dpkg`, `wget`/`curl` available. Reuse these instead
of re-implementing e.g. apt source-list generation.

**`docker_run/*.sh` and `docker_compose/*.yaml`** — two parallel ways of launching
the same set of services (Gitea, Jellyfin, Postgres/PostGIS, pgAdmin, MinIO,
ToolJet, QGIS containers); `docker_run/*.sh` are plain `docker run` invocations,
`docker_compose/*.yaml` are Compose equivalents for a subset. `docker_images/*.dockerfile`
holds the custom image definitions (QGIS LTR/nightly, Debian/Ubuntu act-runner)
these reference.

**`launchers/*.desktop`** — `.desktop` files for GUI launchers; `link.sh` symlinks
them into the desktop environment's expected location. Icons referenced by these
live in `icons/`.

## Secrets: git-crypt

Some files are encrypted at rest in git via `git-crypt` (see `.gitattributes`):
`tools/wake_on_lan.sh`, `notes/**`, `settings/.zshenv`, `settings/.env`. These will
appear as binary/garbage in a plain checkout unless the repo has been unlocked with
`git-crypt unlock <keyfile>`. Never add real secrets to files that aren't covered
by a `filter=git-crypt` pattern in `.gitattributes` — add the pattern first.
