#!/usr/bin/env zsh

set -euo pipefail

eval "$(goenv init -)"

goenv install -s 1.19.2
goenv global 1.19.2
