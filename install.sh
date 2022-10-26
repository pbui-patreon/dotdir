#!/usr/bin/env bash

set -exo pipefail

sudo apt-get update
sudo apt-get install -y tmux fzf vim silversearcher-ag

# Add fzf bindings to shell
echo 'source /usr/share/doc/fzf/examples/key-bindings.bash' >> ~/.bashrc

# Clone my vim setup
gh clone paydro/vim-config ~/.vim
cd ~/.vim
git submodule update --init
cd -
