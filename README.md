# Denny's rc-files

A small public dotfiles collection for quickly getting a familiar shell,
readline, and tmux setup on classroom machines or unfamiliar computers.

This repository is meant to be easy to read, copy, and adapt. It is not a full
workstation bootstrap.

## Fast Install

Install the default high-use files:

- `.bashrc`
- `.inputrc`
- `.tmux.conf`

```bash
curl -fsSL https://rc.denny.one/install | bash
```

## Common Options

Preview what would happen:

```bash
curl -fsSL https://rc.denny.one/install | bash -s -- --dry-run
```

Install the default files plus `.gitconfig`:

```bash
curl -fsSL https://rc.denny.one/install | bash -s -- --with-git
```

Install only selected files:

```bash
curl -fsSL https://rc.denny.one/install | bash -s -- --only .bashrc .inputrc
```

Install all shared rc files:

```bash
curl -fsSL https://rc.denny.one/install | bash -s -- --all
```

The direct installer URL is also available:

```bash
curl -fsSL https://rc.denny.one/setup.sh | bash
```

If GitHub Pages or DNS is not available yet, use the raw GitHub fallback:

```bash
curl -fsSL https://raw.githubusercontent.com/denny0223/rc-files/master/setup.sh | bash
```

## What The Installer Does

The installer clones or updates this repository at `~/rc-files`, then symlinks
the selected files into your home directory.

If a target file already exists, it is moved to a timestamped backup directory:

```text
~/rc_backup-YYYYmmdd-HHMMSS/
```

Files that are already linked to `~/rc-files` are skipped.

The installer requires `git`, `bash`, and `curl`.
