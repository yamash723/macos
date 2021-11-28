## ----------------------------------------
##  Vim
## ----------------------------------------
vim-plug-install() {
  vim  +'PlugInstall --sync' +qa
  nvim +'PlugInstall --sync' +qa
}
vim-plug-update() {
  vim  +'PlugUpdate --sync' +qa
  nvim +'PlugUpdate --sync' +qa
}
vim-plug-clean() {
  vim  +'PlugClean --sync' +qa
  nvim +'PlugClean --sync' +qa
}

## ----------------------------------------
##  Brew
## ----------------------------------------
brew-install() {
  brew bundle --file ./Brewfile
}
brew-update() {
  brew update -v
  brew upgrade -v
}
brew-clean() {
  brew bundle cleanup --file ./Brewfile -fv
}
brew-list() {
  brew bundle dump > ./Brewfile
}

## ----------------------------------------
##  Tmux
## ----------------------------------------
tmux-plug-intall() {
  /bin/bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}
tmux-plug-update() {
  /bin/bash ~/.tmux/plugins/tpm/scripts/update_plugin.sh
}
tmux-plug-clean() {
  /bin/bash ~/.tmux/plugins/tpm/scripts/clean_plugins.sh
}

## ----------------------------------------
##  VSCode
## ----------------------------------------
vscode-plug-install() {
  plugins=$(diff <(code --list-extensions | sort) <(cat ./Vsplug | sort) | grep '>' | cut -f2 -d' ')
  echo $plugins | while read plugin; do
    code --install-extension ${plugin}
  done
}
vscode-plug-updates() {
  plugins=$(code --list-extensions)
  echo $plugins | while read plugin; do
    code --install-extension ${plugin}
  done
}
vscode-plug-clean() {
  plugins="$(diff <(cat ./Vsplug | sort) <(code --list-extensions | sort) | grep '>' | cut -f2 -d' ')"
  echo $plugins | while read plugin; do
    code --uninstall-extension ${plugin}
  done
}
vscode-plug-list() {
  code --list-extensions > ./Vsplug
}

## ----------------------------------------
##  Zinit
## ----------------------------------------
zinit-plug-install() {
  source ~/.zshrc
}
zinit-plug-update() {
  zinit self-update
  zinit update
}
zinit-plug-clean() {
  zinit delete --clean
}

## ----------------------------------------
##  Npm
## ----------------------------------------
npm-install() {
  npm install -g $(cat ./Npmfile)
}
npm-update() {
  npm update -g npm
  npm update -g
}

## ----------------------------------------
##  Pip
## ----------------------------------------
pip-install() {
  pip3 install -r ./Pipfile
}
pip-update() {
  pip install --upgrade pip
  pip freeze | cut -d'=' -f1 | xargs -n1 pip install --upgrade
}

## ----------------------------------------
##  ssh
## ----------------------------------------
sshp() {
  HOST=`cat ~/.ssh/config | fzf | awk "{ print \$2 }"`;
  ssh ${HOST};
}

## ----------------------------------------
##  Install Github Release
## ----------------------------------------
dlgr() {
  read repo"?type https://api.github.com/repos/{author}/{repo}/releases/latest : ";
  URL=`curl -s "${repo}" | grep "browser_download_url" | cut -d '"' -f 4 | fzf`
  curl -sOL ${URL}
}

## ----------------------------------------
##  System Colors
## ----------------------------------------
alias pw='python -m pywal -i'

## ----------------------------------------
##  tar
## ----------------------------------------
tz() { tar zcvf "$1.tar.gz" "$1"; }
extract() {
  case "$1" in
    *.tar.gz|*.tgz)  tar xzvf   "$1";;
    *.tar.xz)        tar Jxvf   "$1";;
    *.zip)           unzip      "$1";;
    *.lzh)           lha e      "$1";;
    *.tar.bz2|*.tbz) tar xjvf   "$1";;
    *.tar.Z)         tar zxvf   "$1";;
    *.gz)            gzip -d    "$1";;
    *.bz2)           bzip2 -dc  "$1";;
    *.Z)             uncompress "$1";;
    *.tar)           tar xvf    "$1";;
    *.arj)           unarj      "$1";;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

## ----------------------------------------
##  misc
## ----------------------------------------
resize_img() {
  input_dir="$1"
  for target in $(ls -d "$input_dir"/*); do
    info=$(identify -format '%w\n%h' "$target")
    length=$(echo "$info" | sort -nr | head -n1)
    filename=$(basename "$target")
    convert -background black -gravity center "$target" -resize ${length}x${length} -extent ${length}x${length} ./resized_"$filename"
  done
}
alias hf='hyperfine --max-runs 3'
alias k6run='k6 run --vus 10 --duration 40s'
alias shfmt="shfmt -i 2 -bn -ci -sr -l -w"
