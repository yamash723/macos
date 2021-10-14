epy() {
  python -c "from ${1} import main; main()"
}

alias mkrun="monkeytype list-modules | grep -v '^test' | xargs -n1 monkeytype run apply"
