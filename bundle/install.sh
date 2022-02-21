#! /bin/bash
set -eux
EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

## ========== Brew Bundle ==========
brew upgrade
brew bundle --file "${EXEPATH}"/Brewfile

## ========== Xcode ==========
# sudo xcodebuild -license accept

## ========== Rust ==========
rustup-init -y
source "${HOME}"/.cargo/env
rustup component add rls --toolchain stable
rustup component add rust-src --toolchain stable
rustup component add rls-preview --toolchain stable
rustup component add rust-analysis --toolchain stable
rustup update stable
cargo install $(cat "${EXEPATH}"/Cargofile)

## ========== Fish ==========
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
curl -L https://get.oh-my.fish | fish
omf install bobthefish

fisher install 0rax/fish-bd
fisher install jethrokuan/fzf

## ========== iTerm2 ==========
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

## ========== VSCode ==========
if ! ${TESTMODE}; then
  for plugin in $(cat "${EXEPATH}"/Vsplug); do
    code --install-extension "${plugin}"
  done
fi
