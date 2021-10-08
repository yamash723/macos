cnew() {
  cargo new $1 --bin;
}
alias cbl='cargo build'
alias cre='cargo release'
alias crn='cargo run'
alias cck='cargo check'
alias rrc='rustc ./main.rs && ./main'
alias watr='RUST_LOG=DEBUG cargo -vv watch -x run'
