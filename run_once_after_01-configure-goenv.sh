#!/usr/bin/env zsh

set -euo pipefail

eval "$(goenv init -)"

goenv install -s 1.18.3
goenv global 1.18.3
