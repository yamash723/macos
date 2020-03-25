#! /usr/local/bin/zsh

local -A opthash
zparseopts -D -A opthash -- -force -help

if [[ -n ${opthash[(i)--help]} ]]; then
        echo "Add option --force to install without checking." && exit;
fi

if [[ -z ${opthash[(i)--force]}  ]]; then
        read Ans"?Your file will be overwritten(Y/n): ";
        if [[ $Ans != 'Y' ]]; then echo 'Canceled' && exit; fi;
fi

EXEPATH=$0:A:h

## ----------------------------------------
##	Brew Bundle
## ----------------------------------------
brew upgrade
brew bundle --file ${EXEPATH}/Brewfile
git lfs install

## ----------------------------------------
##	Xcode
##      - Required to run after Brew,
##      - because xcode is installed by Cask.
## ----------------------------------------
sudo xcodebuild -license accept

## ----------------------------------------
##	Npm Bundle
## ----------------------------------------
npm update -g npm
npm install -g $(cat ${EXEPATH}/Npmfile)

## ----------------------------------------
##	Pip Bundle
## ----------------------------------------
pip3 install --upgrade pip
pip3 install -r ${EXEPATH}/Pipfile

## ----------------------------------------
##	Rust Bundle
## ----------------------------------------
rustup-init -y
source ${HOME}/.cargo/env
rustup component add rls --toolchain stable
rustup component add rust-src --toolchain stable
rustup component add rls-preview --toolchain stable
rustup component add rust-analysis --toolchain stable

## ----------------------------------------
##	Git
## ----------------------------------------
sudo ln -sfnv /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/diff-highlight

## ----------------------------------------
##	Tmux
## ----------------------------------------
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## ----------------------------------------
##	MySQL
## ----------------------------------------
# mysql_secure_installation

## ----------------------------------------
##	iTerm2
## ----------------------------------------
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
ln -sfnv ${EXEPATH}/com.googlecode.iterm2.plist ${HOME}/Library/Preferences/com.googlecode.iterm2.plist

## ----------------------------------------
##	Alfred
## ----------------------------------------
mkdir -p ${HOME}/Library/Application\\\ Support/Alfred
ln -sfnv ${EXEPATH}/Alfred.alfredpreferences ${HOME}/Library/Application\\\ Support/Alfred/Alfred.alfredpreferences

## ----------------------------------------
##	Neovim
## ----------------------------------------
mkdir -p ${HOME}/.config/nvim
curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## ----------------------------------------
##	VSCode
##      - Github Actions doesn't support this,
##      - because they don't have GUI,
##      - so option --test will avoid this.
## ----------------------------------------
if [[ -z "${opthash[(i)--test]}" ]]; then
	plugins=($(cat ${EXEPATH}/VSCodePluginfile))
	for plugin in ${plugins}; do
		code --install-extension ${plugin}
	done
fi;

## ----------------------------------------
##	Karabiner
## ----------------------------------------
mkdir -p ${HOME}/.config/karabiner
ln -sfnv ${EXEPATH}/karabiner.json ${HOME}/.config/karabiner/karabiner.json

## ----------------------------------------
##	Rectangle
## ----------------------------------------
ln -sfnv ${EXEPATH}/com.knollsoft.Rectangle.plist ${HOME}/Library/Preferences/com.knollsoft.Rectangle.plist
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 2
