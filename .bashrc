[ -n "$PS1" ] && source ~/.bash_profile;
export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin
export AWS_REGIONS="us-west-2 ap-southeast-2"
#alias awshell="aws-vault exec production --no-session -- bash"
awsv() { aws-vault exec "$@" --no-session -- bash;}

