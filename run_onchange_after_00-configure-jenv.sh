#!/usr/bin/env zsh

set -euo pipefail

eval "$(jenv init -)"
jenv enable-plugin export
jenv enable-plugin gradle

jenv global 1.8
jenv shell 1.8
