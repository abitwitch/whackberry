#!/bin/sh


gen_btc_wallet(){
  PRIVATE_KEY="ECDSA"
  PUBLIC_KEY="ECDSA.pub"
  BITCOIN_PRIVATE_KEY="bitcoin"
  BITCOIN_PUBLIC_KEY="bitcoin.pub"
  
  echo "Generating private key"
  openssl ecparam -genkey -name secp256k1 -rand /dev/random -out $PRIVATE_KEY
  
  echo "Generating public key"
  openssl ec -in $PRIVATE_KEY -pubout -out $PUBLIC_KEY
  
  echo "Generating Bitcoin private key"
  openssl ec -in $PRIVATE_KEY -outform DER|tail -c +8|head -c 32|xxd -p -c 32 > $BITCOIN_PRIVATE_KEY
  
  echo "Generating Bitcoin public key"
  openssl ec -in $PRIVATE_KEY -pubout -outform DER|tail -c 65|xxd -p -c 65 > $BITCOIN_PUBLIC_KEY
  
  echo BTC PRIVATE_KEY
  cat $BITCOIN_PRIVATE_KEY
  echo BTC ADDRESS
  cat $BITCOIN_PUBLIC_KEY
}


gen_eth_wallet(){
  MAX_KEY=fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
  NUL_KEY=0000000000000000000000000000000000000000000000000000000000000000
  PRIVATE_KEY=$NUL_KEY
  while [[ ! $PRIVATE_KEY > $NUL_KEY ]] || [[ $PRIVATE_KEY > $MAX_KEY ]]
  do
    PRIVATE_KEY=$(openssl rand -rand /dev/random -hex 32)
  done
  echo ETH PRIVATE_KEY
  echo $PRIVATE_KEY
  echo ETH ADDRESS
  echo TODO
}


gen_eth_wallet2(){


  # Generate the private and public keys
  openssl ecparam -name secp256k1 -genkey -noout | openssl ec -text -noout > key

  # Extract the public key and remove the EC prefix 0x04
  cat key | grep pub -A 5 | tail -n +2 | tr -d '\n[:space:]:' | sed 's/^04//' > pub

  # Extract the private key and remove the leading zero byte
  cat key | grep priv -A 3 | tail -n +2 | tr -d '\n[:space:]:' | sed 's/^00//' > priv
  
  echo -n ff8a2e795888d2175d8621da0e1542cb35cbd39d29b67604667bd8600ef7b9fe > priv

  # Generate the hash and take the address part
  cat pub | openssl dgst -sha3-256 | sed 's|.*= ||' | tail -c 41 > address
  
#  cat pub | keccak-256sum -x -l | tr -d ' -' | tail -c 41 > address

  echo ETH PRIVATE_KEY
  cat priv
  echo ETH ADDRESS
  cat address
}


gen_btc_wallet

gen_eth_wallet

gen_eth_wallet2


