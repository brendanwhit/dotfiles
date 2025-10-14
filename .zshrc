# for general auto completions
autoload -Uz compinit && compinit

export GEM_HOME=$HOME/.gem/ruby/2.6.0 
export PATH=$PATH:$HOME/bin:/usr/local/sbin:$GEM_HOME/bin:$HOME/.local/bin
export VAULT_ADDR=https://vault.faraday.ai

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH=$PATH:/usr/local/sbin
# use all of the upgraded GNU utils installed by findutils
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

# set neovim as default editor
export EDITOR=/usr/local/bin/nvim

# be able to save LazyVim in a new config dir
alias lazyvim='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
source ~/fzf-git.sh/fzf-git.sh
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

# point to qsv auto completions
source /usr/local/share/zsh/site-functions

# load and use rbenv
eval "$(rbenv init - zsh)"

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

delete-stale-branches() {
    git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D
}

# function that allows for separate clean up functionality in github
# avoids cluttering PRs
cleanup-branch() {
    local branch_name="housekeeping/$(date +%Y-%m-%d)-${1:-cleanup}"

    if [ ! -d ~/worktrees ]; then
        mkdir -p ~/worktrees
    fi

    git worktree add ~/worktrees/"$branch_name" master

    # might be useful to cd to model_train
    local model_train="~/worktrees/$branch_name/workers/model_train"
    # Detect and open IDE
    if command -v pycharm >/dev/null 2>&1; then
        # Open PyCharm from command line (location varies by OS)
        pycharm $model_train >/dev/null 2>&1 &
    elif command -v code >/dev/null 2>&1; then
        # Open VS Code in new window
        code -n $model_train
    else
        echo "Neither PyCharm nor VS Code found. Opening directory only."
        cd $model_train
    fi

    # Create the branch
    cd $model_train
    # copy the venv for pdm installs
    cp "$OLDPWD/.venv" .
    git checkout -b "$branch_name"

    echo "Created and switched to new cleanup branch: $branch_name"
    echo "Original work directory preserved at: $OLDPWD"
}

# Complementary cleanup function
cleanup-remove() {
    local current_dir=$(pwd)
    if [[ $current_dir == ~/worktrees/* ]]; then
        cd -
        git worktree remove "$current_dir"
        echo "Removed worktree and returned to original directory"
    else
        echo "Not in a worktree directory"
    fi
}
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
