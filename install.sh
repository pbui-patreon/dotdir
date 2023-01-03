#!/usr/bin/env bash

set -exo pipefail

BASEDIR="$( cd "$( dirname "$0" )" && pwd )"

sudo apt-get update
sudo apt-get install -y man-db tmux vim silversearcher-ag dns-utils

if [[ ! -e "${HOME}/.fzf/bin/fzf" ]]; then
  gh repo clone junegunn/fzf ~/.fzf
  ~/.fzf/install --all
fi

# Clone my vim setup

if [[ ! -d "${HOME}/.vim" ]]; then
  gh repo clone paydro/vim-config ~/.vim
  cd ~/.vim

  # My personal vim uses git@ urls for submodules. This doesn't work well when
  # provisioning an rdev environment since we only have the personal access token
  # and not an SSH key. Therefore, change git submodule urls to use HTTPS to
  # enable cloning with github personal access token.
  #
  # i.e., git@github.com:junegunn/goyo.vim.git -> https://github.com/junegunn/goyo.vim.git
  # sed --in-place --expression 's$git@github.com:\(.*\)$https://github.com/\1$g' .gitmodules
  git submodule sync
  git submodule update --init
  cd -
fi

cp $BASEDIR/tmux.conf ~/.tmux.conf
mkdir -p ~/.ssh
cp $BASEDIR/ssh_rc ~/.ssh/rc
cp $BASEDIR/gitconfig ~/.gitconfig
cp $BASEDIR/gitignore ~/.gitignore
cp $BASEDIR/profile ~/.profile

# patreon_py conf
echo "Installing python-lsp-server into patreon_py"
if [[ -d "/home/dev/patreon_py" ]]; then
    cd ~/patreon_py
    ./venv/bin/pip install 'python-lsp-server[all]'
    cd -
fi
