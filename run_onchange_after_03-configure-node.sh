#!/usr/bin/env bash

set -euo pipefail

brew link --overwrite node@16
npm install --location=global firebase-tools
