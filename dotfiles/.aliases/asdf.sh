asdf_install() {
  for plugin in $(cat ./.tool-versions | cut -d' ' -f1); do
    asdf plugin-add "${plugin}"
  done
  asdf install
  while read local_version; do
    asdf local $local_version
  done < ./.tool-versions
}

source $(brew --prefix asdf)/asdf.sh
bash $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
