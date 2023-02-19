alias bi := brew-install

brew-install:
  brew bundle --no-upgrade --file ./Brewfile

# 新規マシンを設定する時のコマンド
machine-init: macos-system-apply brew-install terminal-init install-devtool-latest

# macosの設定値を適用する
macos-system-apply:
  osascript -e 'tell application "System Preferences" to quit' > /dev/null 2>&1
  /bin/bash ./system/macos.sh

terminal-init:
  chsh -s /bin/zsh
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

asdf-add-plugin:
  -asdf plugin add ruby
  -asdf plugin-add python
  -asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git
  -asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
  -asdf plugin-add helmfile https://github.com/feniix/asdf-helmfile.git

asdf-install-latest: asdf-add-plugin
  asdf install ruby latest
  asdf install python latest
  asdf install kubectl latest
  asdf install helm latest
  asdf install helmfile latest

install-devtool-latest: asdf-install-latest && rust-init
  asdf global ruby $(asdf latest ruby)
  asdf global python $(asdf latest python)
  asdf global kubectl $(asdf latest kubectl)
  asdf global helm $(asdf latest helm)
  asdf global helmfile $(asdf latest helmfile)

  tfenv install latest
  -helm plugin install https://github.com/databus23/helm-diff

install-krew-plugin:
  kubectrl krew install iexec
  kubectrl krew install neat
  kubectrl krew install resource-capacity
  kubectrl krew install stern

rust-init:
  rustup-init -y
  source "${HOME}"/.cargo/env
  rustup component add rls --toolchain stable
  rustup component add rust-src --toolchain stable
  rustup component add rls-preview --toolchain stable
  rustup component add rust-analysis --toolchain stable
  rustup component add rustfmt --toolchain stable
  rustup component add clippy --toolchain stable
  rustup update stable
