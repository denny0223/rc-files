# AGENTS.md

## Project Overview

This repository is a small, public dotfiles collection. It is meant to be easy
to read, copy, and adapt, not a locked-down machine image. Prefer changes that
teach a durable pattern over changes that encode one specific workstation.

The installer in `setup.sh` clones or updates this repository at `~/rc-files`
and symlinks an explicit set of selected rc files back into the home directory.
The default install is intentionally small for quick use on classroom machines
or unfamiliar computers.

## Repository Shape

- `README.md`: minimal install instructions.
- `setup.sh`: backup-and-symlink installer.
- `.bashrc`: Bash history, prompt, PATH helpers, and optional tool activation.
- `.gitconfig`: shared Git defaults and aliases.
- `.tmux.conf`: tmux keybindings and history settings.
- `.inputrc`: readline history search and completion behavior.
- `.ideavimrc` / `.vrapperrc`: Vim-like editor integration settings.
- `.w3m/keymap` and `.w3m/keymap.default`: w3m keymap customization and
  reference defaults.

## Maintenance Principles

- Keep the repository usable as a public learning reference. Avoid committing
  machine-specific paths, private credentials, API keys, tokens, local email
  identities, or organization-only assumptions.
- Prefer optional, guarded configuration for tools that may not be installed.
  A shell startup file should not fail just because an optional tool is absent.
- Do not hard-code a full local toolchain into committed shell startup files.
  Show examples in comments when a path is useful to learn from but should not
  be enabled for everyone.
- Keep shell code simple and portable for ordinary Bash usage. Avoid clever
  abstractions unless they remove real duplication or prevent a common footgun.
- Preserve the repository's small surface area. Do not add package managers,
  lockfiles, generated output, or framework scaffolding unless the user has
  explicitly decided to grow the project in that direction.
- Treat uncommitted changes as user work. Inspect them when relevant, but do not
  stage, rewrite, or discard them unless the user asks.

## Bash Configuration Guidance

The `.bashrc` is intentionally a template-like personal shell configuration.
PATH management should remain explicit and readable.

- Use `path_prepend` when a path should take priority over system commands.
- Use `path_append` when a path is only a fallback or supplemental tool source.
- Check directories before adding them to `PATH`.
- Keep optional toolchains such as Cargo or Android SDK paths as commented
  examples unless the user explicitly wants them enabled by default.
- Prefer `mise` as an optional runtime and developer-tool manager. Keep its
  activation guarded with `command -v mise` and include the install URL in the
  comment so readers can discover it: `https://mise.jdx.dev/`.
- Do not commit secret environment variables. Secrets belong in an untracked
  local file, a shell-specific private config, or a secret manager, not in this
  public repository.

## Git Configuration Guidance

`.gitconfig` is shared configuration. Be careful with settings that reveal or
assume one person's identity or credential flow.

- Generic Git behavior, aliases, colors, editor choice, and pull/push defaults
  are reasonable shared settings.
- Personal `[user]` identity and credential helper wiring may be appropriate for
  one machine but should not be treated as universally reusable without explicit
  user confirmation.

## Installer Guidance

`setup.sh` is intentionally small and direct. It is optimized for fast
`curl | bash` use while keeping the install scope explicit. If editing it:

- Preserve the explicit install sets instead of scanning every top-level file.
- Keep the default install limited to `.bashrc`, `.inputrc`, and `.tmux.conf`.
- Keep `.gitconfig` opt-in through `--with-git` or `--all` because it can affect
  identity and credential behavior.
- Preserve the backup-before-symlink behavior with timestamped backup
  directories.
- Be careful with destructive operations in `$HOME`.
- Prefer clear POSIX-style shell where practical.
- Test syntax with `bash -n setup.sh`.
- Think through idempotency before changing backup, update, or symlink
  behavior.

## Validation Checklist

Use focused checks for the files touched:

- Shell files: `bash -n .bashrc setup.sh`
- Git diff hygiene: `git diff --check`
- Bash startup smoke test when `.bashrc` changes:
  `env -i HOME="$HOME" USER="$USER" TERM=xterm PATH=/usr/local/bin:/usr/bin bash --rcfile .bashrc -i -c 'command -v bash >/dev/null'`
- Review staged scope before committing: `git diff --cached --stat` and
  `git status --short`
