# for general auto completions
autoload -Uz compinit && compinit

# general PATH setting
export PATH="$PATH:$HOME/bin:/usr/local/sbin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# use all of the upgraded GNU utils installed by brew by adding them to path
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  # gnubin
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
fi

# set neovim as default editor
export EDITOR="/usr/local/bin/nvim"

# be able to save LazyVim in a new config dir
alias lazyvim='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
source $HOME/fzf-git.sh/fzf-git.sh
# use fd for the default fzf command
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# ripgrep->fzf->vim [QUERY]
# see more: https://junegunn.github.io/fzf/tips/ripgrep-integration/#ripgrep-integration-a-walkthrough
rfv() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            $EDITOR {1} +{2}     # No selection. Open the current line in Vim.
          else
            $EDITOR +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

# Adding support for git branch name in the shell
autoload -Uz vcs_info

# style choices
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

# actually read the branch
precmd() {
    # As always first run the system so everything is setup correctly.
    vcs_info
    # And then just set PS1, RPS1 and whatever you want to. This $PS1
    # is (as with the other examples above too) just an example of a very
    # basic single-line prompt. See "man zshmisc" for details on how to
    # make this less readable. :-)
    if [[ -z ${vcs_info_msg_0_} ]]; then
        # Oh hey, nothing from vcs_info, so we got more space.
        # Let's print a longer part of $PWD...
        PS1="%F{3}%D{%a %Y-%b-%d %L:%M:%S} %F{5}[%F{2}%n@%m%F{5}] %F{3}%5~%f%# "
    else
        # vcs_info found something, that needs space. So a shorter $PWD
        # makes sense.
        PS1="%F{3}%D{%a %Y-%b-%d %L:%M:%S} %F{5}[%F{2}%n@%m%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%f%# "
    fi
}

delete-stale-branches() {
    git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D
}

# Global variables to track worktree state for cleanup
typeset -g CLEANUP_BRANCH_ORIGINAL_DIR=""
typeset -g CLEANUP_BRANCH_WORKTREE_DIR=""

# function that allows for separate clean up functionality in github
# avoids cluttering PRs
cleanup-branch() {
    local branch_name="housekeeping/$(date +%Y-%m-%d)-${1:-cleanup}"
    CLEANUP_BRANCH_ORIGINAL_DIR=$(pwd)

    # Get the relative path from git root to current directory
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -z "$git_root" ]; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local rel_path=$(git rev-parse --show-prefix 2>/dev/null)
    rel_path=${rel_path%/}  # Remove trailing slash if present

    if [ ! -d ~/worktrees ]; then
        mkdir -p ~/worktrees
    fi

    # Get default branch (main or master)
    local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [ -z "$default_branch" ]; then
        default_branch="master"
    fi

    # Create worktree with new branch
    local worktree_dir=~/worktrees/"$branch_name"
    git worktree add -b "$branch_name" "$worktree_dir" "$default_branch"
    CLEANUP_BRANCH_WORKTREE_DIR="$worktree_dir"

    # Build the target directory path
    local target_dir="$worktree_dir"
    if [ -n "$rel_path" ]; then
        target_dir="$worktree_dir/$rel_path"
    fi

    # CD to the equivalent directory in the worktree
    cd "$target_dir"

    # Copy .venv if it exists in the original directory
    if [ -d "$CLEANUP_BRANCH_ORIGINAL_DIR/.venv" ]; then
        cp -r "$CLEANUP_BRANCH_ORIGINAL_DIR/.venv" .
    fi

    echo "Created and switched to new cleanup branch: $branch_name"
    echo "Working directory: $target_dir"

    # Open the directory in $EDITOR
    if [ -n "$EDITOR" ]; then
        $EDITOR .
    else
        echo "No \$EDITOR set"
    fi
}

# Complementary cleanup function
cleanup-remove() {
    if [ -z "$CLEANUP_BRANCH_WORKTREE_DIR" ]; then
        echo "No active worktree to remove (CLEANUP_BRANCH_WORKTREE_DIR not set)"
        return 1
    fi

    # Get the main repository's git directory while still in the worktree
    local main_git_dir=$(git rev-parse --git-common-dir 2>/dev/null)
    local main_repo=$(dirname "$main_git_dir")

    local worktree_root="$CLEANUP_BRANCH_WORKTREE_DIR"

    # Return to the original directory if set, otherwise go home
    if [ -n "$CLEANUP_BRANCH_ORIGINAL_DIR" ]; then
        cd "$CLEANUP_BRANCH_ORIGINAL_DIR"
    else
        cd ~
    fi

    # Remove the worktree from the main repo context
    git -C "$main_repo" worktree remove "$worktree_root" --force

    # Remove the directory if it still exists (e.g., untracked files)
    if [ -d "$worktree_root" ]; then
        rm -rf "$worktree_root"
    fi

    echo "Removed worktree: $worktree_root"
    echo "Returned to: $(pwd)"

    # Clear the global variables
    CLEANUP_BRANCH_ORIGINAL_DIR=""
    CLEANUP_BRANCH_WORKTREE_DIR=""
}
# alias to work on config bare git
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# basic aliases
alias ls="ls --color=auto --group-directories-first"
alias ll='ls -lahF'

# load Faraday settings
source "$HOME/faraday.zsh"
