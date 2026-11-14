<p align="center">
  <img src="assets/banner-kurenai.svg" alt="kurenai: system info for the terminal" width="100%">
</p>

<p align="center">
  <a href="https://github.com/swbasmx/kurenai/releases/latest"><img src="https://img.shields.io/github/v/release/swbasmx/kurenai?color=FF0000&label=release" alt="Latest release"></a>
  <a href="#installation"><img src="https://img.shields.io/badge/bash-4%2B-4EAA25?logo=gnubash&logoColor=white" alt="Bash 4+"></a>
  <a href="#compatibility"><img src="https://img.shields.io/badge/platform-Linux-FF0000?logo=linux&logoColor=white" alt="Linux"></a>
  <a href="#license"><img src="https://img.shields.io/badge/license-MIT-FF0000" alt="MIT"></a>
  <a href="https://github.com/swbasmx/kurenai/actions/workflows/ci.yml"><img src="https://github.com/swbasmx/kurenai/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <strong>System info for the terminal. Neon red, two columns, a live monitor and no weird dependencies.</strong>
</p>

<p align="center">
  <a href="README.md">Español</a> · <a href="README.en.md">English</a>
</p>

<p align="center">
  <a href="#installation">Install</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#monitor-mode">Monitor</a> ·
  <a href="#how-it-works">How it works</a> ·
  <a href="#performance">Performance</a> ·
  <a href="#development">Development</a>
</p>

---

<p align="center">
  <img src="assets/preview.png?v=6" alt="kurenai in a GNOME terminal" width="100%">
</p>

<p align="center">
  <em>Rendered with GNOME Terminal's engine (VTE) at 80 columns. IPs are examples.</em>
</p>

```bash
curl -fsSLO https://raw.githubusercontent.com/swbasmx/kurenai/main/install.sh && sudo bash install.sh
```

`kurenai` is a system info panel for the terminal, written in Bash. It shows system, hardware, performance and memory data in a red interface, with bars, a CPU sparkline and a layout that adapts to the terminal width. Run it once, or leave it running as a live monitor.

Repository: <https://github.com/swbasmx/kurenai>

## Why kurenai

- **One Bash file.** No binary, no runtime, no modules. You can read the whole thing in one sitting.
- **No dependencies.** Just `awk`, `sed`, `df`, `/proc` and `/sys`. `curl`, `lspci` and `nvidia-smi` are optional.
- **Opens fast.** Around 0.6 s on a modest machine, so the shell autostart doesn't get in your way.
- **A real monitor mode.** The same panel refreshes every second, with pause and adjustable interval.
- **Fits the width.** Two columns from 78 characters, a single column down to 40.
- **Respects your terminal.** `NO_COLOR`, `TERM=dumb`, redirections, `-q`, `-n`, truecolor with 256 and 16 color fallbacks.
- **Clean install and uninstall.** A marked block in `~/.bashrc`, a backup, and nothing else.
- **Tested.** 22 smoke, PTY and install tests, plus CI on every push.

It's not btop and it's not neofetch in a different color: it's a compact panel that fits a normal terminal and stays out of your way.

## Contents

- [Why kurenai](#why-kurenai)
- [What is it?](#what-is-it)
- [Features](#features)
- [Live monitor](#live-monitor)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Monitor mode](#monitor-mode)
- [Uninstall](#uninstall)
- [How it works](#how-it-works)
- [Performance](#performance)
- [Privacy](#privacy)
- [Configuration](#configuration)
- [Compatibility](#compatibility)
- [Development](#development)
- [Troubleshooting](#troubleshooting)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Credits](#credits)

## What is it?

`kurenai` collects data from `/proc`, `/sys`, `df`, `lspci`, `nvidia-smi` and, if allowed, a public IP service. It turns that into a compact terminal panel, without images or third-party dependencies.

The name comes from **紅** (*kurenai*), crimson or deep red in Japanese.

There are two ways to use it:

- **One-shot**: run `kurenai` and it draws the panel once. This is what the shell autostart uses.
- **Monitor**: run `kurenai -m` and the panel refreshes every second. It's meant to stay open in a terminal or a side pane.

## Features

- **Neon red**: `#FF0000` in truecolor, with 256 and 16 color fallbacks.
- **Configurable accent**: `KURENAI_ACCENT="R G B"` changes the color without editing the script.
- **Adaptive two columns**: from 78 columns; a single column on narrow terminals.
- **Bars** for CPU, temperature, load, GPU, RAM, swap, disk and battery.
- **Live monitor mode** with `-m`: adjustable interval, pause, manual refresh and a clean exit with `q`.
- **Readable load**: the bar compares load against core count, and the detail shows `load/cores`.
- **CPU sparkline** with the last 8 samples.
- **Adjustable animation length** with `-t SECONDS`; accepts a decimal comma.
- **Automatic language**: detects `LANG`/`LC_ALL`, and `-l` forces `es` or `en`.
- **Useful data**: kernel, shell, uptime, CPU, GPU, LAN, public IP, temperature and battery.
- **Public IP cache** with a 15 minute TTL; failures are remembered for 60 seconds and `-r` forces a refresh.
- **Parallel lookups**: the public IP and GPU are resolved in the background while the rest of the data is collected.
- **Optional autostart** when a terminal opens, guarded so it doesn't repeat in subshells.
- **Idempotent, upgradeable installer**: rewrites the marked block in `~/.bashrc`, never duplicates it, and keeps a backup.
- **Respects your terminal**: `NO_COLOR`, `TERM=dumb`, redirections, `-q` and environment variables to disable network or animation.

## Live monitor

<p align="center">
  <img src="assets/monitor.gif?v=6" alt="kurenai -m refreshing the panel live" width="100%">
</p>

> Monitor mode GIF rendered with VTE at 80 columns; the GIF refreshes at 0.5 s and the default interval is 1 s. IPs are examples.

`kurenai -m` keeps the panel open and redraws it every second. See [Monitor mode](#monitor-mode) for details.

## Requirements

- Linux.
- Bash 4+.
- Standard utilities: `awk`, `sed`, `df`, `ip` or `hostname`, and access to `/proc` and `/sys`.
- Optional:
  - `curl` for the public IP lookup.
  - `lspci` for the GPU model.
  - `nvidia-smi` or `gpu_busy_percent` for GPU usage.
  - `/sys/class/power_supply` for the battery.
  - `/sys/class/hwmon` or thermal zones for temperature.

## Installation

```bash
curl -fsSLO https://raw.githubusercontent.com/swbasmx/kurenai/main/install.sh
sudo bash install.sh
```

The installer downloads `kurenai`, copies it to `~/.local/bin/kurenai`, saves a copy of `~/.bashrc` to `~/.bashrc.kurenai.bak` and updates the marked autostart block. If the block already exists, it is rewritten to point at the right prefix instead of being duplicated.

If you run it with `sudo`, it installs for the user who invoked it, not for `root`.

| Option | Description |
| --- | --- |
| `--prefix DIR` | Install directory. Defaults to `~/.local/bin`. |
| `--bashrc FILE` | Shell config file. Defaults to `~/.bashrc`. |
| `--no-autostart` | Installs the command but removes the autostart block. |
| `--repo URL` | Alternative URL to download `kurenai` from. |

`PREFIX`, `BASHRC` and `REPO_RAW` can also be passed as environment variables. If your `sudo` uses `env_reset`, pass the paths as arguments (`sudo bash install.sh --prefix ...`), because sudo may drop those variables.

Open a new terminal or reload your config:

```bash
source ~/.bashrc
```

### From the repo

```bash
git clone https://github.com/swbasmx/kurenai.git
cd kurenai
./install.sh
```

### Without autostart

If you only want the command available:

```bash
./install.sh --no-autostart
```

Or install the file by hand:

```bash
install -m 755 kurenai ~/.local/bin/kurenai
```

Make sure `~/.local/bin` is on your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

You can also run it straight from the repo:

```bash
./kurenai
```

## Usage

```bash
kurenai            # animated panel
kurenai -t 1.5     # 1.5 second animation
kurenai -l en      # English output
kurenai -q         # no animation
kurenai -n         # skip the public IP lookup
kurenai -r         # refresh the public IP
kurenai -m         # live monitor mode (1 s)
kurenai -m -i 0.5  # monitor every 0.5 s
kurenai -V         # version
kurenai -h         # help
```

| Option | Description |
| --- | --- |
| `-r`, `--refresh` | Ignore the cache and look up the public IP again. |
| `-n`, `--no-net` | Don't look up the public IP. |
| `-q`, `--no-anim` | Disable the animation and print static output. |
| `-t`, `--time S` | Animation length in seconds (default `0.3`). Accepts a decimal comma. `0` disables it. |
| `-m`, `--monitor` | Live monitor mode. Requires an interactive terminal. |
| `-i`, `--interval S` | Monitor refresh interval, 0.25–10 s. Implies `-m`. |
| `--frames N` | Render N frames and exit. Useful for tests. |
| `-l`, `--lang L` | Language: `es` or `en` (also `es_ES`, `en_US`, etc.). Defaults to detection from `LANG`/`LC_ALL`. |
| `-V`, `--version` | Print the version. |
| `-h`, `--help` | Print the help. |

### Environment variables

| Variable | Effect |
| --- | --- |
| `KURENAI_LANG=es\|en` | Forces the language. |
| `KURENAI_NO_NET=1` | Skips the public IP lookup. Same as `-n`. |
| `KURENAI_NO_ANIM=1` | Disables the animation. Same as `-q`. |
| `KURENAI_ACCENT="R G B"` | Main color, for example `"0 255 180"`. Defaults to `"255 0 0"`. |
| `KURENAI_BAR_W=4..14` | Bar width. Defaults to `10`. |
| `KURENAI_WIDTH=40..84` | Forces the panel width; handy for screenshots or tests. |
| `KURENAI_INTERVAL=1` | Default monitor interval, in seconds. |

```bash
KURENAI_ACCENT="0 255 180" kurenai
KURENAI_NO_NET=1 kurenai -q
```

If you want the autostart to use them, define these variables **before** the `# >>> kurenai >>>` block in `~/.bashrc`.

## Monitor mode

```bash
kurenai -m
kurenai -m -i 0.5
kurenai -m -n          # hide the public IP
```

Monitor mode switches to the alternate screen, hides the cursor and redraws the panel every second. It keeps the same look: neon red, `▰/▱` bars, `─` rules and two columns.

| Key | Action |
| --- | --- |
| `q` | Quit and restore the terminal. |
| `p` | Pause/resume data collection. |
| `+` / `-` | Increase/decrease the interval (0.25–10 s). |
| `r` | Refresh static data and the public IP. |
| `h` | Show/hide the help footer. |
| `Ctrl-C` | Quit and restore the terminal. |

Notes:

- Autostart is still the one-shot panel; the monitor is opt-in with `-m`.
- The public IP is looked up once per session (or when you press `r`); `-n` hides it.
- The disk is refreshed every 5 s; the rest of the metrics on every tick.
- If the terminal is below the minimum size, it shows a notice and waits for a resize or `q`.
- The mouse wheel and arrow keys are ignored: they neither scroll the panel nor force a redraw.
- On NVIDIA, GPU usage is polled in the background every few seconds so it never blocks the UI.

## Uninstall

```bash
curl -fsSLO https://raw.githubusercontent.com/swbasmx/kurenai/main/uninstall.sh
sudo bash uninstall.sh
```

You can also run it from the repo:

```bash
cd kurenai
./uninstall.sh
```

It removes `~/.local/bin/kurenai`, the marked block in `~/.bashrc` and the public IP cache. It leaves the rest of the file alone. If you installed with `--prefix` or `--bashrc`, use the same values to uninstall. `--keep-cache` keeps `${XDG_CACHE_HOME:-$HOME/.cache}/kurenai`.

```bash
./uninstall.sh --prefix ~/.local/bin --bashrc ~/.bashrc
./uninstall.sh --keep-cache
```

## How it works

### Data sources

```text
/proc/stat, /proc/meminfo, /proc/loadavg, /proc/uptime
/sys/class/thermal, /sys/class/hwmon, /sys/class/power_supply
/sys/class/drm, df, lspci, nvidia-smi
curl (public IP only, optional)
                    │
                    ▼
        collect_static / collect_dynamic_tick
                    │
                    ▼
        render_panel / render_metrics / render_footer
                    │
                    ▼
                terminal
```

### One-shot

1. Static data is collected: kernel, shell, CPU, cores, max frequency, GPU and LAN.
2. The public IP and GPU usage are resolved in the background.
3. Dynamic metrics are collected: uptime, load, RAM, swap, disk, temperature, battery and CPU.
4. Detail strings for each row are computed.
5. The panel is drawn and, if there's a TTY, the rule and bars are animated.

### Monitor

The monitor loop is deliberately light:

```text
read a key (timeout = interval)
  ↓
collect dynamic metrics
  ↓
draw the whole frame in a single write
  ↓
repeat
```

- Static data is collected once on entry and on `r`.
- CPU usage is the delta of `/proc/stat` between ticks; there is no extra `sleep`.
- The sparkline keeps the last 8 samples.
- The disk is refreshed every 5 ticks.
- The public IP is looked up once per session, except on `r`.
- NVIDIA GPU usage is updated by a background poller; AMD/Intel are read from sysfs.
- The frame is built, the screen is cleared, and then written in one go to avoid flicker.
- On exit, the cursor, terminal mode and previous screen are restored.

### Rendering and layout

- **Width**: uses `tput cols` on a TTY, otherwise `COLUMNS`; `KURENAI_WIDTH` overrides it. Clamped to 84, with a 40 minimum.
- **Two columns** from 78 columns; a single column on narrow terminals.
- **Centering**: in monitor mode, the panel is centered if the terminal is wider than the panel.
- **Headers**: `─` lines with the label centered and bold.
- **Bars**: `▰` for filled and `▱` for empty.
- **Sparkline**: `▁▂▃▄▅▆▇█`.
- **Color**: truecolor, then 256, then 16 colors. Disabled without a TTY, when `NO_COLOR` is set, or when `TERM=dumb`.

### Cache

The public IP is stored in `${XDG_CACHE_HOME:-$HOME/.cache}/kurenai/public-ip` for 15 minutes. Failures are remembered for 60 seconds so a network-less start doesn't block. The file is created with `600` permissions.

### Language

`LC_ALL`, `LC_MESSAGES`, `LANGUAGE` or `LANG` are detected in that order. `-l es|en` forces it, and so does `KURENAI_LANG` from the environment.

### Project layout

| File | Purpose |
| --- | --- |
| `kurenai` | Main script, single file. |
| `install.sh` | Installer and autostart. |
| `uninstall.sh` | Uninstaller. |
| `tests/smoke.sh` | Smoke, PTY and install cycle tests. |
| `Makefile` | `make test`, `make lint`, `make check`. |
| `.github/workflows/ci.yml` | Lint and tests in CI. |
| `assets/banner-kurenai.svg` | README banner. |
| `assets/preview.png` | Panel screenshot. |
| `assets/monitor.gif` | Monitor mode demo. |

## Performance

Measured on a modest machine, with `-n -q` to isolate data collection:

- One-shot panel: around **0.6 s**.
- Monitor at 1 s: around **6% of one core** and **7 MB RSS**.
- The disk is refreshed every 5 s; the rest of the metrics on every tick.
- Absolute numbers vary with system load.

To reduce usage:

```bash
kurenai -m -i 2     # refresh every 2 s
kurenai -m -n       # skip the IP lookup
# press p to pause
```

## Privacy

The public IP is looked up at `api.ipify.org` (with `ifconfig.me/ip` as a fallback) and stored in the local cache in plain text. The file is created with `600` permissions.

To never look it up:

```bash
kurenai -n
kurenai -m -n
```

or set `KURENAI_NO_NET=1`. There is no telemetry, no accounts, and no data sent anywhere beyond that lookup.

The installer backs up `~/.bashrc` before modifying it, validates the downloaded script with `bash -n` and downloads over HTTPS.

## Configuration

Almost everything lives at the top of the script:

| Constant / variable | What it controls |
| --- | --- |
| `BAR_W` / `KURENAI_BAR_W` | Bar width, 4..14. Defaults to 10. |
| `TTL` | IP cache lifetime in seconds. Defaults to 900. |
| `TTL_NEG` | Failed IP lookup cache lifetime. Defaults to 60. |
| `LEFT_W` | Left column width. Defaults to 34. |
| `GAP` | Gap between columns. Defaults to 3. |
| `KURENAI_ACCENT` | Main color as `"R G B"`. Defaults to `"255 0 0"`. |
| `KURENAI_INTERVAL` | Default monitor interval, in seconds. |

To change the color without editing the script:

```bash
KURENAI_ACCENT="0 255 180" kurenai
```

Or set it in `~/.bashrc`:

```bash
export KURENAI_ACCENT="0 255 180"
```

Put it before the `# >>> kurenai >>>` block so it also affects autostart.

## Compatibility

- Linux. The script depends on `/proc` and `/sys`.
- Bash 4+.
- A UTF-8 terminal with ANSI support; works in modern terminals, tmux and SSH.
- Truecolor, 256 colors and 16 colors.
- Optional: `curl`, `lspci`, `nvidia-smi`, battery and sensors.
- Tested on Linux with Bash 5.1; the code avoids features missing from Bash 4.

## Development

```bash
git clone https://github.com/swbasmx/kurenai.git
cd kurenai
./kurenai -n -q
bash tests/smoke.sh
make check   # bash -n + shellcheck + smoke tests
```

The tests cover widths from 40 to 120 columns, both languages, top rule alignment, environment variables, monitor mode under a PTY, a small terminal, and the install/uninstall cycle in a temporary `HOME`.

The GitHub Actions workflow runs lint and tests on every push and pull request.

### Adding a metric

1. Collect the value in `collect_dynamic_tick` (or `collect_static` if it never changes).
2. Add the label to `t()` and `init_labels`.
3. Add the row in `render_metrics` or in the `render_panel` body.
4. Check that the width still adds up at 40, 78, 80 and 84 columns.
5. Run `make check`.

## Troubleshooting

- **The rule or columns look cut off**: use a terminal of at least 40 columns; the panel is clamped to 84. `KURENAI_WIDTH=80` forces a specific width.
- **No GPU shown**: install `pciutils` (`lspci`). GPU usage needs `nvidia-smi` or `gpu_busy_percent`.
- **No temperature shown**: check that `/sys/class/hwmon` or `/sys/class/thermal` exists.
- **The IP is slow or offline**: use `-n` or `KURENAI_NO_NET=1`; the lookup has a 1 s timeout and the failure cache lasts 60 s.
- **`kurenai: command not found`**: add `~/.local/bin` to `PATH` (`export PATH="$HOME/.local/bin:$PATH"`).
- **Autostart doesn't run**: check that `~/.bashrc` is the file your shell reads and that the block exists only once.
- **I want to undo autostart**: `./install.sh --no-autostart` or `./uninstall.sh`.
- **Monitor mode won't start**: it needs interactive stdin and stdout; run it directly in a terminal, not with redirected output.
- **I want to reduce monitor usage**: use `-m -i 2` to refresh every 2 s, or `p` to pause it.
- **It looks wrong in a non-UTF-8 terminal**: the panel uses `─`, `▰`, `▱` and `█`; use a UTF-8 locale.

### FAQ

**Does it need root?** No. The installer uses `sudo` only to run as your user and write to your `HOME`.

**Does it work on macOS?** No. It depends on Linux `/proc` and `/sys`.

**Is it a neofetch clone?** It's inspired by the idea of showing system information in the terminal, but it's an independent Bash implementation.

**Why Bash?** So it's a single file that's easy to install and read, with no extra runtime.

**Can I use it in scripts?** Yes: `-q` gives static output and `-n` skips the network lookup. It respects `NO_COLOR`, `TERM=dumb` and redirections.

## Roadmap

Ideas for future versions, without commitment:

- Per-core bars.
- Larger CPU/RAM graphs.
- Network RX/TX with history.
- Top processes list.
- More color themes.

## Contributing

- Open an issue before large changes.
- Keep the script in one file and add no new dependencies.
- Run `make check` before sending a PR.
- Match the existing style: Bash 4+, clean `shellcheck`, green tests.
- Document any new option or variable in this README.

---

<p align="center">
  If <strong>kurenai</strong> is useful to you, star the repo. It helps other people find it.
</p>

<p align="center">
  <a href="https://github.com/swbasmx/kurenai/stargazers"><img src="https://img.shields.io/github/stars/swbasmx/kurenai?style=for-the-badge&color=FF0000&labelColor=1a0000" alt="GitHub stars"></a>
</p>

## License

MIT. See [LICENSE](LICENSE).

## Credits

Inspired by the idea behind [neofetch](https://github.com/dylanaraps/neofetch) and by the visual density of tools like `btop` and `fastfetch`. `kurenai` is an independent implementation in Bash, unrelated to those projects.
