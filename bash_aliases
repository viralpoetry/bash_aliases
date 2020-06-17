#!/usr/bin/env bash

DEV_VAULT_ADDR='https://vault.dev.example'
DEV_VAULT_USER='abcd'
PROD_VAULT_ADDR='https://vault.prod.example'
PROD_VAULT_USER='efgh'
VAULT_AUTH_PATH='ldap'

alias ag='ag --hidden'
alias fn='ssh -fN jumphost'
alias kluce='vim ~/.ssh/config'
alias venv='source ~/projects/venv/bin/activate'
alias sslreq='openssl req -noout -text -in'
alias sslcert='openssl x509 -noout -text -in'

function devvault() { __vault_auth "dev" "$DEV_VAULT_ADDR" "$DEV_VAULT_USER"; }
function prodvault() { __vault_auth "prod" "$PROD_VAULT_ADDR" "$PROD_VAULT_USER"; }

function __vault_auth() {
  echo "Insert $1 password: "
  read -sr VAULT_PASSWD
  export VAULT_ADDR=$2
  unset VAULT_TOKEN
  r=$(curl -s --request POST --data '{"password": "'"$VAULT_PASSWD"'"}' $VAULT_ADDR/v1/auth/$VAULT_AUTH_PATH/login/$3)
  token=$(echo "$r" | jq -r '.auth.client_token')
  if [ "$token" = "null" ]
  then
      echo "Error: token not present in response."
  else
      export VAULT_TOKEN=$token
      echo "$1 vault authenticated."
  fi
  unset VAULT_PASSWD
  unset token
  unset r
}

# tardir() {
#     tar -zcvf "$1.tar.gz" "$1"
# }
#
# untardir() {
#     tar -zxvf "$1"
# }
