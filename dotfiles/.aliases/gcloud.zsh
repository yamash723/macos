[ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ] && source "${HOME}/google-cloud-sdk/path.zsh.inc"
[ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ] && source "${HOME}/google-cloud-sdk/completion.zsh.inc"

command -v gcloud > /dev/null 2>&1 || echo "You need to install gcloud shell"

alias gcpcurrentproject='gcloud config list'
alias gcpregion='gcloud compute regions list'
alias gcpprojectsls='gclooud projects list'
alias gcpcoproject='gcloud config set project'

alias gcls='gcloud components list'
alias gcup='gcloud components update'
alias gcin='gcloud components install'

alias gsmb='gsutil mb'
alias gsls='gsutil ls'
alias gsrm='gsutil rm'
alias gscp='gsutil cp'

alias gnls='gcloud compute networks list'
alias gnlssubnet='gcloud compute networks subnets list --sort-by=NETWORK'

gcrnet() {
  networkname="$1"
  projectname="$2"
  subnetmode="$3"
  gcloud compute networks create "$networkname" --project="$projectname" --subnet-mode="$subnetmode" --mtu=1460 --bgp-routing-mode=regional
}

gcrsubnet() {
  networkname="$1"
  projectname="$2"
  subnetname="$3"
  iprange="$4"
  region="$5"
  gcloud compute networks subnets create "$subnetname" --range="$iprange" --network="$networkname" --project="$projectname" --region="$region"
}

gcrfirewall() {
  firewallname="$1"
  networkname="$2"
  allowname="$3"
  gcloud compute firewallrules create "$firewallname" --network "$networkname" --allow "$allowname"
}
