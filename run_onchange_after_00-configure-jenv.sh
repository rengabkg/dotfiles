#!/usr/bin/env zsh

set -euo pipefail

eval "$(jenv init -)"
jenv enable-plugin export
jenv enable-plugin gradle

jenv add /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home

jenv global 17.0
jenv shell 17.0
