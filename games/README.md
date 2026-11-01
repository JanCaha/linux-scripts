# Games setup

This folder contains scripts for setting up the emulation environment used for DOS and arcade games.

## Included scripts

- `install_emulators.sh` — installs MAME, DOSBox, Java, basic download utilities, and DBGL into `APPS_DIRECTORY`, creates a DBGL desktop launcher, and writes a minimal EmulationStation MAME config (`~/.emulationstation/es_systems.cfg`) when missing.
- `configure_mame.sh` — creates a simple MAME directory layout and a basic `mame.ini`.
- `configure_dosbox.sh` — creates game-specific DOSBox configs.
- `download_game.sh` — downloads and extracts a ZIP/7z archive from a URL into a chosen game directory.
- `common.sh` — shared variables used by the other scripts.

## Default layout

The scripts use a `Games` folder under the current user home:

- `~/Games/mame/roms`
- `~/Games/mame/artwork`
- `~/Games/dosbox/games`
- `~/Games/downloads`

Override the defaults by exporting `GAMES_ROOT`, `MAME_ROOT`, or `DOSBOX_ROOT` before running the scripts.

## Typical usage

```bash
cd ~/Scripts/games
./install_emulators.sh
./configure_mame.sh
./configure_dosbox.sh "$HOME/Games/dosbox/games/dune2" "dune2"
./download_game.sh dune2 "https://example.com/dune2.zip" "$HOME/Games/dosbox/games/dune2"
```

## Notes

- Use source URLs that you are allowed to download and extract.
- MAME ROMs are often region- and version-specific; make sure the ROM set matches the emulator version you install.
- DOSBox game configs should be adjusted (timing, sound, CPU cycles, resolution) for each game if needed.
