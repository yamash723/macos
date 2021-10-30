#! /bin/bash
set -u
EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

## ========== Brew Bundle ==========
brew upgrade
brew bundle --file "${EXEPATH}"/Brewfile

## ========== Xcode ==========
# sudo xcodebuild -license accept

## ========== Npm ==========
npm update -g npm
npm install -g $(cat "${EXEPATH}"/Npmfile)

## ========== Pip ==========
pip3 install --upgrade pip
pip3 install -r "${EXEPATH}"/Pipfile

## ========== Rust ==========
rustup-init -y
source "${HOME}"/.cargo/env
rustup component add rls --toolchain stable
rustup component add rust-src --toolchain stable
rustup component add rls-preview --toolchain stable
rustup component add rust-analysis --toolchain stable
cargo install $(cat "${EXEPATH}"/Cargofile)

## ========== Perl ==========
# PERL_MM_USE_DEFAULT=1 PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
# eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
# cpan App::cpanminus
# cpanm $(cat ${EXEPATH}/Cpanfile)

## ========== Zsh ==========
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
zinit self-update
source "${HOME}"/.zshrc

## ========== NeoVim ==========
curl -fLo "${HOME}"/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +'PlugInstall --sync' +qa

## ========== Tmux ==========
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
/bin/bash "${HOME}"/.tmux/plugins/tpm/scripts/install_plugins.sh

## ========== MySQL ==========
# mysql_secure_installation
# - This can be automated by expect, but can't be public.
# - [Ref] https://gist.github.com/Mins/4602864

## ========== Gcloud ==========
# curl https://sdk.cloud.google.com | /bin/bash -s -- --disable-prompts

## ========== iTerm2 ==========
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

## ========== Anyenv ==========
# if [ ! -d ${HOME}/.config/anyenv/anyenv-install ]; then
#   expect -c "
#     spawn anyenv install --init
#     expect \"Do you want to checkout ? \[y\/N\]: \"
#     send \"y\n\"
#     expect eof
#   "
# fi

## ========== Yabai ==========
# brew services start skhd
# brew services start yabai

## ========== Remote pbcopy ==========
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  curl -fsSLo pbcopy-linux-amd64.tar.gz https://github.com/skaji/remote-pbcopy-iterm2/releases/latest/download/pbcopy-linux-amd64.tar.gz
  tar --remove-files xf pbcopy-linux-amd64.tar.gz
  mv pbcopy ~/pbcopy
fi

## ========== VSCode ==========
if ! ${TESTMODE}; then
  for plugin in $(cat "${EXEPATH}"/Vsplug); do
    code --install-extension "${plugin}"
  done
fi
