#!/usr/bin/env bash

set -exo pipefail

sudo apt-get update
sudo apt-get install -y tmux vim silversearcher-ag

gh repo clone junegunn/fzf ~/.fzf
~/.fzf/install --all

# fzf integration with silversearcher find files
echo "export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node-modules -g .'" >> ~/.bashrc

# Aliases to move around the filesystem
echo 'alias ppy="cd ~/patreon_py; source venv/bin/activate"' >> ~/.bashrc
echo 'alias start_mypy="dmypy kill; dmypy run -- --show-column-numbers --show-error-codes patreon test"'


# Clone my vim setup
gh repo clone paydro/vim-config ~/.vim
cd ~/.vim

# My personal vim uses git@ urls for submodules. This doesn't work well when
# provisioning an rdev environment since we only have the personal access token
# and not an SSH key. Therefore, change git submodule urls to use HTTPS to
# enable cloning with github personal access token.
#
# i.e., git@github.com:junegunn/goyo.vim.git -> https://github.com/junegunn/goyo.vim.git
sed --in-place --expression 's$git@github.com:\(.*\)$https://github.com/\1$g' .gitmodules
git submodule sync
git submodule update --init
cd -

# Tmux configuration
cat >~/.tmux.conf << "EOF"
set -g default-terminal "xterm-256color"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
set -as terminal-overrides ',*:Setulc=\E[58::2:f

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

set-option -g history-limit 500000
setw -g mode-keys vi

# Enable mouse pleasantries
set -g mouse on

# Focus events help vim detect when files change with vim's autoread setting
set -g focus-events on

# Allow pbcopy/pbpaste to work in tmux
# Requires brew install reattach-to-user-namespace
set -g default-shell $SHELL
#set -g default-command "reattach-to-user-namespace -l ${SHELL}"

## Setup friendly copy/paste for mac
# Setup 'v' and 'y' to begin/copy selection as in Vim
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

# Update default binding of `Enter` to also use copy-pipe
# note: not sure if I need to handle both copy-mode and copy-mode-vi ... /shrug
unbind-key -T copy-mode Enter
bind-key -T copy-mode Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
unbind-key -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

# mouse rebinds
unbind-key -T copy-mode-vi MouseDragEnd1Pane
bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"


# useful styling tips:
# https://github.com/sbernheim4/dotfiles/blob/251a30db0dbbd2953df35bfa0ef43e92ce15b752/tmux/.tmux.conf#L1
set-option -g status-justify left
set-option -g status-style fg=colour203,bg=colour237
set-option -g pane-border-lines heavy
set-option -g pane-border-style fg=colour240
set-option -g pane-active-border-style fg=colour203
set-window-option -g window-status-format "#I: #W "
set-window-option -g window-status-current-format " #I: #W "

setw -g window-status-current-style fg=colour237,bg=colour203,bold


#set-option -g pane-active-border-fg colour67
#set-window-option -g window-status-current-bg colour8

set -sg escape-time 0
EOF

# patreon_py conf
if [[ -d "/home/dev/patreon_py" ]]; then
    cd ~/patreon_py
    ./venv/bin/pip install 'python-lsp-server[all]'
    cd -
fi
