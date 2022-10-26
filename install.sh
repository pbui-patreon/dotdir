#!/usr/bin/env bash

set -exo pipefail

sudo apt-get update
sudo apt-get install -y tmux fzf vim silversearcher-ag

# Add fzf bindings to shell
echo 'source /usr/share/doc/fzf/examples/key-bindings.bash' >> ~/.bashrc

# Clone my vim setup
gh repo clone paydro/vim-config ~/.vim
cd ~/.vim

# My personal vim uses git@ urls for submodules. This doesn't work well when
# provisioning an rdev environment since we only have the personal access token
# and not an SSH key. Therefore, change git submodule urls to use HTTPS to
# enable cloning with github personal access token.
#
# i.e., git@github.com:junegunn/goyo.vim.git -> https://github.com/junegunn/goyo.vim.git
sed --in-place --expression 's$git@github.com:\(.*\)$https://github.com/\1$g'
git submodule sync
git submodule update --init
cd -
