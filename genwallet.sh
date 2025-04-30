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
}


gen_eth_wallet(){
  PRIVATE_KEY=0
  #while PRIVATE_KEY!=0 and not greater than ffffffff ffffffff ffffffff fffffffe baaedce6 af48a03b bfd25e8c d0364141
    #openssl rand -rand /dev/random -hex 32
}


gen_btc_wallet


