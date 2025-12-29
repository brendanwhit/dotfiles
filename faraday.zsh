# Faraday related terminal settings
export GEM_HOME=$HOME/.gem/ruby/2.6.0 
export PATH=$PATH:$GEM_HOME/bin:$HOME/.local/bin
export VAULT_ADDR=https://vault2.faraday.ai

# load and use rbenv
eval "$(rbenv init - zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# update PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# enable shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi


# cd to model_train - finds it from common locations or searches
cmt() {
    # Known locations (fastest path)
    local known_paths=(
        "$HOME/faraday/fdy/workers/model_train"
        "$HOME/fdy/workers/model_train"
    )

    # Check known paths first
    for kp in "${known_paths[@]}"; do
        if [[ -d "$kp" ]]; then
            cd "$kp" && return 0
        fi
    done

    # Check if we're already in a fdy repo - find model_train relative to repo root
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" && -d "$git_root/workers/model_train" ]]; then
        cd "$git_root/workers/model_train" && return 0
    fi

    # Check worktrees for model_train
    if [[ -d "$HOME/worktrees" ]]; then
        local worktree_mt=$(find "$HOME/worktrees" -maxdepth 3 -type d -name "model_train" 2>/dev/null | head -1)
        if [[ -n "$worktree_mt" ]]; then
            cd "$worktree_mt" && return 0
        fi
    fi

    # Fallback: search from home using fd (fast) or find
    local found
    if command -v fd >/dev/null 2>&1; then
        found=$(fd -t d -H --max-depth 5 '^model_train$' "$HOME" 2>/dev/null | grep -E 'workers/model_train$' | head -1)
    else
        found=$(find "$HOME" -maxdepth 5 -type d -name "model_train" -path "*/workers/*" 2>/dev/null | head -1)
    fi

    if [[ -n "$found" ]]; then
        cd "$found" && return 0
    fi

    echo "Could not find model_train directory" >&2
    return 1
}
