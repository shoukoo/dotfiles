#!/bin/bash

set -euxo pipefail

# Make sure you logged in to ICloud 
ta="$HOME/ICloud"
so="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
if [ ! -d "$ta" ]; then
  ln -s "$so" $ta
fi
