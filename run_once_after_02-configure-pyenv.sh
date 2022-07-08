#!/usr/bin/env zsh

set -euo pipefail

eval "$(pyenv init -)"

pyenv install -s 3.10.5
pyenv install -s 2.7.18

pyenv global 3.10.5
