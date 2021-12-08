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
alias gcauthservice='gcloud auth activate-service-account --key-file'

alias gcappdep='gcloud app deploy app.yaml'
alias gcappbr='gcloud app browse'

alias gsmb='gsutil mb'
alias gsls='gsutil ls'
alias gsrm='gsutil rm'
alias gscp='gsutil cp'
alias gsacegt='gsutil acl get'
alias gsacestpv='gsutil acl set private'
alias gsacestpb='gsutil acl ch -u AllUsers:R'
alias gsencrypt='gsutil rewrite -k'
alias gssetlife='gsutil lifecycle set'
alias gssetversion='gsutil versioning set'
alias gsrsync='gsutil rsync -r'

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

alias gcldpllist='gcloud deployment-manager types list'
gcldpdep() {
  name="$1"
  configfile="$2"
  gcloud deployment-manager deployments create "$name" --config="$configfile" --preview
  echo "run 'gcloud deploy-manager deployments update to deploy actually'"
}

gcbdocker() {
  gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/"$1" .
}

alias gkecon='gcloud container clusters get-credentials'
# edit deployment yaml after submit (or use kustomize edit set image)
# kubectl create deployment *** --image=***
# kubectl expose deployment *** --type=LoadBalancer --port 80 --target-port 8000
# kubectl set image deployment/*** {name}=***
# kubectl edit deployment ***
# kubectl get deploy *** -o yaml
