# qgis-compile

Daily rebuild of all QGIS git worktrees found under `$HOME/QGIS` (main checkout plus
any linked worktrees, e.g. `/QGIS/<branch>`). Runs via a systemd timer that wakes the
machine from suspend if needed.

## Install

```bash
./install.sh
```

This copies `qgis-compile.sh` to `/usr/local/bin/`, installs the `.service` and
`.timer` units to `/etc/systemd/system/`, then enables and starts the timer.

## How it works

- `qgis-compile.timer` fires daily at 04:00 (`OnCalendar`), with:
  - `WakeSystem=true` — sets an RTC wakealarm to wake the machine from **suspend**
    for this run. Does **not** wake it from a full shutdown/poweroff.
  - No `Persistent=true` — if the machine was fully powered off at 04:00 (so the
    wakealarm couldn't fire), the run is simply skipped; it will **not** run late
    on the next boot. It only runs at the next scheduled 04:00.
- `qgis-compile.service` runs `qgis-compile.sh` as user `cahik`.
- `qgis-compile.sh` runs `git worktree list` in `$HOME/QGIS` to find every worktree,
  then runs `cmake --workflow build-for-testing` in each one. A failure in one
  worktree doesn't stop the rest — failed folders are listed at the end and the
  script exits non-zero if any failed.
- **Special case: `/QGIS/install`**. This worktree is built differently:
  1. First it merges upstream (ported from `git_merge_upstream_function` in
     `settings/.zshrc`): stashes local changes if any, `git fetch upstream`,
     merges `upstream/master` (falling back to `upstream/main`), then pops the
     stash back.
  2. Then it runs `cmake --workflow release_opt_no_tests_install` instead of
     `build-for-testing`.

  All other worktrees are unaffected and keep using `build-for-testing`.
- **Sleep prompt**: once all builds finish, the script checks whether you're
  actively using the machine (via `loginctl`'s per-session `IdleHint`). If any
  session is not idle, it skips sleeping entirely and leaves the machine
  running. Otherwise it asks "Go back to sleep? [Y/n]" with a 10 second
  timeout defaulting to yes. Since the timer runs unattended (no terminal
  attached), the prompt effectively times out immediately and the machine
  suspends right after the build. If you run the script manually from a
  terminal while idle, you get the full 10 seconds to answer.

## Check it's set up and when it will run next

```bash
systemctl list-timers qgis-compile.timer
systemctl status qgis-compile.timer
systemctl status qgis-compile.service
```

`list-timers` shows the next scheduled run and the last run time.

## View logs

```bash
# Full output of the most recent run
journalctl -u qgis-compile.service -n 200

# Follow live (e.g. right after a manual trigger)
journalctl -u qgis-compile.service -f

# Only today's runs
journalctl -u qgis-compile.service --since today

# All historical runs across boots
journalctl -u qgis-compile.service -b all
```

## Run it manually (don't wait for 04:00)

```bash
sudo systemctl start qgis-compile.service
journalctl -u qgis-compile.service -f
```

## Change the schedule or folders

- Edit the `OnCalendar=` line in `qgis-compile.timer` for a different time.
- The script auto-discovers folders from `git worktree list`, so new worktrees
  under `$HOME/QGIS` are picked up automatically — no edits needed.
- To point at a different main checkout, change `QGIS_MAIN_DIR=` in
  `qgis-compile.service`.

After editing any unit file, re-run `install.sh` (or manually `sudo cp` the changed
file, then `sudo systemctl daemon-reload` and, for timer changes,
`sudo systemctl restart qgis-compile.timer`).

## Uninstall

```bash
sudo systemctl disable --now qgis-compile.timer
sudo rm /etc/systemd/system/qgis-compile.service /etc/systemd/system/qgis-compile.timer
sudo rm /usr/local/bin/qgis-compile.sh
sudo systemctl daemon-reload
```

## Caveats

- `WakeSystem=` relies on RTC wakealarm support in the hardware/firmware; some
  laptops ignore it while on battery or with certain BIOS power settings.
- If the machine is fully powered off (not suspended) at the scheduled time, the
  job will not wake it — it will only run late (via `Persistent=true`) once the
  machine is next booted.
- The build uses whatever `cmake --workflow build-for-testing` preset is defined in
  each worktree's `CMakePresets.json` — make sure that preset exists and is
  configured correctly in each worktree.
- Because the timer run has no attached terminal, the end-of-run sleep prompt
  always times out and defaults to suspending the machine — unless a session's
  `IdleHint` is `no` (i.e. you're actively using the machine when the build
  finishes), in which case sleep is skipped entirely. `IdleHint` is set by the
  desktop environment/display manager based on its own idle timeout, so how
  quickly a session is marked idle depends on your desktop's settings, not this
  script.
