
DEV_VAULT_ADDR  = 'https://vault.dev.example'
DEV_VAULT_USER  = 'abcd'
PROD_VAULT_ADDR = 'https://vault.prod.example'
PROD_VAULT_USER = 'efgh'
VAULT_AUTH_PATH = 'ldap'

alias ag='ag --hidden'
alias fn='ssh -fN jumphost'
alias kluce='vim ~/.ssh/config'
alias venv='source ~/projects/venv/bin/activate'
alias sslreq='openssl req -noout -text -in'
alias sslcert='openssl x509 -noout -text -in'

tardir() {
    tar -zcvf $1.tar.gz $1
}

untardir() {
    tar -zxvf $1
}

devvault() {
  echo "Insert DEV vault password: "
  read -sr VAULT_PASSWD
  VAULT_PASSWD=$VAULT_PASSWD
  export VAULT_ADDR=$DEV_VAULT_ADDR
  unset VAULT_TOKEN
  r=$(curl -s --request POST --data '{"password": "'"$VAULT_PASSWD"'"}' $VAULT_ADDR/v1/auth/$VAULT_AUTH_PATH/login/$DEV_VAULT_USER)
  token=$(echo "$r" | jq -r '.auth.client_token')
  if [ "$token" = "null" ]
  then
      echo "Error: token not present in response."
  else
      export VAULT_TOKEN=$token
      echo "Dev vault authenticated."
  fi
  unset VAULT_PASSWD
  unset token
  unset r
}

prodvault() {
  echo "Insert PROD vault password: "
  read -sr VAULT_PASSWD
  VAULT_PASSWD=$VAULT_PASSWD
  export VAULT_ADDR=$PROD_VAULT_ADDR
  unset VAULT_TOKEN
  r=$(curl -s --request POST --data '{"password": "'"$VAULT_PASSWD"'"}' $VAULT_ADDR/v1/auth/$VAULT_AUTH_PATH/login/$PROD_VAULT_USER)
  token=$(echo "$r" | jq -r '.auth.client_token')
  if [ "$token" = "null" ]
  then
      echo "Error: token not present in response."
  else
      export VAULT_TOKEN=$token
      echo "Dev vault authenticated."
  fi
  unset VAULT_PASSWD
  unset token
  unset r
}
