#!/usr/bin/env bash

set -euo pipefail

echo "Updating nvm"
cd $HOME/.nvm
git fetch
git checkout v0.39.2
