#! /bin/bash
set -eux
EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

## ========== Brew Bundle ==========
brew upgrade
brew bundle --file "${EXEPATH}"/Brewfile

## ========== Xcode ==========
# sudo xcodebuild -license accept

## ========== asdf ==========
asdf plugin add ruby
asdf install ruby latest
asdf global ruby $(asdf latest ruby)

asdf plugin-add python
asdf install python latest
asdf global python $(asdf latest python)

asdf plugin-add nodejs
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)

asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf install kubectl latest
asdf global kubectl $(asdf latest kubectl)

asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm latest
asdf global helm $(asdf latest helm)


asdf plugin-add helmfile https://github.com/feniix/asdf-helmfile.git
asdf install helmfile latest
asdf global helmfile $(asdf latest helmfile)

asdf plugin add tfenv
asdf install tfenv latest
asdf global tfenv $(asdf latest tfenv)

tfenv install latest

helm plugin install https://github.com/databus23/helm-diff

## ========== K8s ==========

kubectl krew install stern
kubectl krew install iexec

## ========== Rust ==========
rustup-init -y

source "${HOME}"/.cargo/env
echo "fish_add_path ~/.cargo/bin" | fish

rustup component add rls --toolchain stable
rustup component add rust-src --toolchain stable
rustup component add rls-preview --toolchain stable
rustup component add rust-analysis --toolchain stable
rustup component add rustfmt --toolchain stable
rustup component add clippy --toolchain stable
rustup update stable
cargo install $(cat "${EXEPATH}"/Cargofile)

## ========== Fish ==========
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
echo "fisher update" | fish

## ========== Starship ==========
curl -sS https://starship.rs/install.sh | sh

## ========== iTerm2 ==========
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

## ========== VSCode ==========
if ! ${TESTMODE}; then
  for plugin in $(cat "${EXEPATH}"/Vsplug); do
    code --install-extension "${plugin}"
  done
fi
