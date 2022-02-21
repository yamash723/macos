#!/bin/bash
set -eux

## ----------------------------------------
##  By default, you don't have any CLI such as git.
##  Run the command below to install dependencies.
##  curl https://raw.githubusercontent.com/yamash723/dotfiles/master/install.sh | /bin/bash -s -- --init
## ----------------------------------------

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "MacOS only available."
  exit 1
fi

TESTMODE=false
shopt -s dotglob
EXEPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)

## ----------------------------------------
##  Functions
## ----------------------------------------
symlink_dotfiles() {
  brew install chezmoi
  chezmoi init --apply https://github.com/yamash723/dotfiles.git
}

configure_system() {
  CWD=${EXEPATH}/system
  osascript -e 'tell application "System Preferences" to quit' > /dev/null 2>&1
  /bin/bash "${CWD}"/macos.sh ${TESTMODE}
}

install_bundle() {
  CWD=${EXEPATH}/bundle
  /bin/bash "${CWD}"/install.sh ${TESTMODE}
}

initialize() {
  if ! ${TESTMODE}; then
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

    sudo softwareupdate --install-rosetta

    brew install gh
    gh auth login
    mkdir -p "${HOME}"/.ghq/github.com/yamash723/macos && cd "$_" || exit 1
    git clone --recursive https://github.com/yamash723/macos .
  fi

  brew tap homebrew/bundle
  brew install fish
  echo $(which fish) | sudo tee -a /etc/shells
  chsh -s $(which fish)

  mkdir -p "${HOME}"/work
}

usage() {
  cat <<- EOS
    Options for install.sh
    =================================================
    init:     Core initialization"
    bundle:   Package installation"
    system:   MacOS system setting"
    dotfiles: Dotfiles installation"
    all:      All installations (except init)"
EOS
}

## ----------------------------------------
##  Main
## ----------------------------------------
argv=$@

if [[ ${argv[@]} =~ "--help" || $# -eq 0 ]]; then
  usage
  exit 0
fi

if [[ ${argv[@]} =~ "--force" ]]; then
  argv=(${argv[@]/"--force"/})
else
  read -p "Your file will be overwritten. OK? (Y/n): " Ans
  [[ ${argv[@]} =~ "--init" ]] && Ans='Y'
  [[ $Ans != 'Y' ]] && echo 'Canceled' && exit 0
fi

if [[ ${argv[@]} =~ "--test" ]]; then
  TESTMODE=true
  argv=(${argv[@]/"--test"/})
fi

if ! ${TESTMODE}; then
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2> /dev/null &
fi

for opt in ${argv[@]}; do
  case $opt in
    --init) initialize ;;
    --bundle) install_bundle ;;
    --system) configure_system ;;
    --dotfiles) symlink_dotfiles ;;
    --all)
      symlink_dotfiles
      install_bundle
      configure_system
      ;;
    *) echo "invalid option $1" ;;
  esac
done
