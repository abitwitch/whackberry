# offlinepasswordmanager

## TODO
- install Xubuntu
- Install
   - https://github.com/pointbiz/bitaddress.org
   - https://github.com/myetherwallet/myetherwallet
   - https://passwordstore.org/
   - https://qtpass.org/
- Download as reference
   - https://www.bitcoin.com/get-started/setting-up-your-own-cold-storage-bitcoin-wallet/
   - https://help.myetherwallet.com/en/articles/6512619-using-mew-offline


## Start system init (online) 
1. Install password manager
   1. `sudo apt-get install pass`
   2. `sudo apt-get install qtpass`
   3. `sudo apt-get install ninvaders`


## Finish system init (offline) 
1. Use system for 5-10 minutes to generate entopy (try `ninvaders`)
2. Generate key
   1. `gpg --default-new-key-algo rsa4096 --gen-key`
   2. Real name: user123
   3. Email: [empty]
   4. `O` for okay
   5. Enter a password

#Install Bitcoin BTC Offline Key Generator
#todo

#Install Etherium ETH Offline Key Generator
#todo
