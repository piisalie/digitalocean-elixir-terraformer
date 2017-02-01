#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

. ~/.asdf/asdf.sh

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

asdf install erlang 19.2
asdf install elixir 1.4.0
asdf global erlang 19.2
asdf global elixir 1.4.0

mix local.hex --force
mix local.rebar --force
