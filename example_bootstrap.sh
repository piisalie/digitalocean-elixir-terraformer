#!/bin/bash

asdf plugin-add elm https://github.com/vic/asdf-elm.git
asdf install elm 0.18.0
asdf global elm 0.18.0

cd app
mix deps.get
cd apps/hanabi_ui
npm install
./node_modules/brunch/bin/brunch b -p
MIX_ENV=prod mix phoenix.digest

cd ../..
MIX_ENV=prod mix release.clean --env=prod
MIX_ENV=prod mix release --env=prod

# build ends up at
# _build/prod/rel/hanabi_umbrella/releases/0.1.0/hanabi_umbrella.tar.gz
