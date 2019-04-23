[ -n "$PS1" ] && source ~/.bash_profile;

#HOME Computer
if [ "$HOSTNAME" == "bealox" ];then
  export GOPATH=/Users/bealox/Projects/go
else
  export GOPATH=$HOME/Documents/go
fi

export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
export AWS_REGIONS="us-west-2 ap-southeast-2"
#alias awshell="aws-vault exec production --no-session -- bash"
awsv() { aws-vault exec "$@" --no-session -- bash;}

