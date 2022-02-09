#!/bin/bash

set -eox pipefail

cluster_file="$HOME/.faws_metadata.json"

function usage () {
  
  cat <<USAGE
    Usage: $0 [-t tag] [--skip-verification]

    Options:
        -h, --help:           print out usage
        -f, --force:          force update cluster metadata
        -c, --console:        open up console
USAGE
  exit 1
}

function fetch_cluster_metadata (){
  touch $cluster_file
  content=$(kubectl get clusterinfo --context pod999 --namespace kube-system -ojson)
  echo "$content" > "$cluster_file"
}

function aws_login() {
  acccount="arn:aws:iam::${3}:role/okta/compute"
  saml2aws login --duo-mfa-option='Duo Push' --profile $1 --region $2 --role $acccount --console
  eval $(saml2aws script --shell bash --profile $1)
  export AWS_PROFILE=$SAML2AWS_PROFILE
  export AWS_REGION=$2
  export SAML2AWS_REGION=$2
}

function fuzzy_search() {
  selected=$(cat "$cluster_file" | jq -jr '.items[] | .metadata.name," ", .spec.awsRegion," ", .spec.awsAccount, "\n"' | fzf)
  aws_login $(echo -n  "$selected")
}

input=${1:-none}

while [ "$input" != "" ]; do
    case $input in
    -f | --force)
        fetch_cluster_metadata
        fuzzy_search
        ;;
    -c | --console)
        saml2aws console
        ;;
    -h | --help)
        usage # run usage function
        ;;
    none)
        if [ ! -f "$cluster_file" ]; then 
          fetch_cluster_metadata
        fi
        fuzzy_search
        ;;
    *)
        usage
        ;;
    esac
    shift # remove the current value for `$input` and use the next
done
