#!/usr/bin/env bash

set -exo pipefail

apt-get update
apt-get install -y tmux fzf vim
