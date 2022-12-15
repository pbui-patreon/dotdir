#!/usr/bin/env bash

set -exo pipefail

BASEDIR="$( cd "$( dirname "$0" )" && pwd )"

sudo unminimize
sudo apt-get update
sudo apt-get install -y man-db tmux vim silversearcher-ag

if [[ ! -e "~/.fzf/bin/fzf" ]]; then
  gh repo clone junegunn/fzf ~/.fzf
  ~/.fzf/install --all
fi

# fzf integration with silversearcher find files
echo "export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node-modules -g .'" >> ~/.bashrc

# Aliases to move around the filesystem
echo 'alias ppy="cd ~/patreon_py; source venv/bin/activate"' >> ~/.bashrc
echo 'alias start_mypy="dmypy kill; dmypy run -- --show-column-numbers --show-error-codes patreon test"' >> ~/.bashrc


# Clone my vim setup

if [[ ! -e "~/.vim" ]]; then
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
fi

cp $BASEDIR/tmux.conf ~/.tmux.conf
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

# clone other useful repos
if [[ ! -e "~/patreon_react_features" ]]; then
  git repo clone patreon/patreon_react_features
fi

if [[ ! -e "~/terraform" ]]; then
  git repo clone patreon/terraform
fi

if [[ ! -e "~/ansible" ]]; then
  git repo clone patreon/ansible
fi
