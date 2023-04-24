source ~/.bashrc

export EDITOR=vim

alias ppy="cd ~/patreon_py && source venv/bin/activate"
alias prf="cd ~/patreon_react_features"
alias tf="cd ~/terraform && source venv/bin/activate"
alias ans="cd ~/ansible"

alias start_mypy='dmypy kill; dmypy run -- --show-column-numbers --show-error-codes patreon test'

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node-modules -g .'

refresh() {
  if [[ -n "${TMUX}" ]]; then
    eval $(tmux show-env -s | grep SSH_AUTH)
  fi
}

source /opt/dotfiles/rdev-common/history.sh
