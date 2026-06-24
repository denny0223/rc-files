#!/usr/bin/env bash
set -euo pipefail

repo_url="https://github.com/denny0223/rc-files.git"
repo_dir="${RC_FILES_DIR:-$HOME/rc-files}"

default_files=(
    ".bashrc"
    ".inputrc"
    ".tmux.conf"
)

git_files=(
    ".gitconfig"
)

extra_files=(
    ".ideavimrc"
    ".vrapperrc"
    ".w3m"
)

dry_run=0
mode="default"
selected_files=()

usage() {
    cat <<'USAGE'
Usage: setup.sh [--dry-run] [--with-git | --all | --only FILE...]

Fast setup:
  setup.sh                         Install .bashrc, .inputrc, and .tmux.conf
  setup.sh --with-git              Install default files plus .gitconfig
  setup.sh --all                   Install all shared rc files
  setup.sh --only .bashrc .inputrc Install exactly the listed files

Options:
  --dry-run    Show planned actions without changing files
  --help       Show this help

When using curl:
  curl -fsSL https://rc.denny.one/install | bash -s -- --dry-run
USAGE
}

die() {
    printf 'setup.sh: %s\n' "$*" >&2
    exit 1
}

contains_file() {
    local needle="$1"
    shift

    local file
    for file in "$@"; do
        [ "$file" = "$needle" ] && return 0
    done

    return 1
}

all_allowed_files() {
    printf '%s\n' "${default_files[@]}" "${git_files[@]}" "${extra_files[@]}"
}

validate_requested_file() {
    local requested="$1"

    if ! contains_file "$requested" "${default_files[@]}" "${git_files[@]}" "${extra_files[@]}"; then
        die "unknown install target: $requested"
    fi
}

parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --dry-run)
                dry_run=1
                shift
                ;;
            --with-git)
                [ "$mode" = "default" ] || die "--with-git cannot be combined with $mode"
                mode="with-git"
                shift
                ;;
            --all)
                [ "$mode" = "default" ] || die "--all cannot be combined with $mode"
                mode="all"
                shift
                ;;
            --only)
                [ "$mode" = "default" ] || die "--only cannot be combined with $mode"
                mode="only"
                shift
                [ "$#" -gt 0 ] || die "--only requires at least one file"

                while [ "$#" -gt 0 ]; do
                    case "$1" in
                        --*)
                            die "--only must be the last option"
                            ;;
                    esac

                    validate_requested_file "$1"
                    selected_files+=("$1")
                    shift
                done
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                die "unknown option: $1"
                ;;
        esac
    done
}

install_files() {
    case "$mode" in
        default)
            printf '%s\n' "${default_files[@]}"
            ;;
        with-git)
            printf '%s\n' "${default_files[@]}" "${git_files[@]}"
            ;;
        all)
            all_allowed_files
            ;;
        only)
            printf '%s\n' "${selected_files[@]}"
            ;;
        *)
            die "unknown install mode: $mode"
            ;;
    esac
}

run() {
    if [ "$dry_run" -eq 1 ]; then
        printf 'Would run: %s\n' "$*"
    else
        "$@"
    fi
}

ensure_repo() {
    command -v git > /dev/null 2>&1 || die "git is required to install rc-files"

    if [ -d "$repo_dir/.git" ]; then
        if git -C "$repo_dir" rev-parse --abbrev-ref --symbolic-full-name '@{u}' > /dev/null 2>&1; then
            run git -C "$repo_dir" pull --ff-only
        else
            printf 'Skip update: %s has no upstream branch\n' "$repo_dir"
        fi
        return
    fi

    [ ! -e "$repo_dir" ] || die "$repo_dir exists but is not a Git repository"
    run git clone "$repo_url" "$repo_dir"
}

is_expected_link() {
    local target="$1"
    local source="$2"

    [ -L "$target" ] || return 1
    [ "$(readlink "$target")" = "$source" ]
}

main() {
    parse_args "$@"

    printf 'Install directory: %s\n' "$repo_dir"
    printf 'Install mode: %s\n' "$mode"

    ensure_repo

    local backup_dir=""
    local source target file timestamp

    while IFS= read -r file; do
        source="$repo_dir/$file"
        target="$HOME/$file"

        if [ ! -e "$source" ]; then
            [ "$dry_run" -eq 1 ] || die "missing source file in repository: $source"
        fi

        if is_expected_link "$target" "$source"; then
            printf 'Skip: %s is already linked to %s\n' "$target" "$source"
            continue
        fi

        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ -z "$backup_dir" ]; then
                timestamp="$(date +%Y%m%d-%H%M%S)"
                backup_dir="$HOME/rc_backup-$timestamp"
                run mkdir -p "$backup_dir"
            fi

            printf 'Backup: %s -> %s/%s\n' "$target" "$backup_dir" "$file"
            run mv "$target" "$backup_dir/$file"
        fi

        printf 'Link: %s -> %s\n' "$target" "$source"
        run ln -s "$source" "$target"
    done < <(install_files)
}

main "$@"
