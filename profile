alias ppy="cd ~/patreon_py"
alias prf="cd ~/patreon_react_features"
alias ppy="work && cd patreon_py && source venv/bin/activate"
alias prf="work && cd patreon_react_features"
alias tf="code && cd terraform && source venv/bin/activate"
alias ans="work && cd ansible"

alias start_mypy='dmypy kill; dmypy run -- --show-column-numbers --show-error-codes patreon test'

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node-modules -g .'
