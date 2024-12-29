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
2. Install Bitcoin BTC Offline Key Generator
   1. `mkdir /home/user/btc`
   2. `cd /home/user/btc`
   3. `wget https://github.com/pointbiz/bitaddress.org/archive/refs/tags/v3.3.0.zip`
   4. `unzip bitaddress.org-v3.3.0.zip`
3. Install Etherium ETH Offline Key Generator
   1. `mkdir /home/user/eth`
   2. `cd /home/user/eth`
   3. `wget https://github.com/MyEtherWallet/MyEtherWallet/releases/download/v6.9.17/MyEtherWallet-v6.9.17-Offline.zip` (get latest version)
   4. `unzip MyEtherWallet-v6.9.17-Offline.zip`
4. Download reference material
   1. `mkdir /home/user/referencepages`
   2. `cd /home/user/referencepages`
   3. Download a pdf of `https://www.bitcoin.com/get-started/setting-up-your-own-cold-storage-bitcoin-wallet/`
   4. Download a pdf of `https://help.myetherwallet.com/en/articles/6512619-using-mew-offline/`
   5. Download a pdf of `https://help.myetherwallet.com/en/articles/6167899-how-to-create-a-cold-wallet-a-k-a-paper-wallet`
6. Download wikipedia
   1. TODO


## Finish system init (offline) 
1. Use system for 5-10 minutes to generate entopy (try `ninvaders`, or browse wikipedia)
2. Set up password manager
   1. Generate key
      1. `gpg --default-new-key-algo rsa4096 --gen-key`
      2. Real name: user
      3. Email: [empty]
      4. `O` for okay
      5. Enter a password (this will be the master password for the password manager)
      6. Note the id of the key. This will be a lond alphanumberic sequence right above "uid"
   2. `pass init key-id-as-noted-above`
3. Generate Bitcoin BTC wallet
   1. Open Firefox and go to `file://home/user/btc/bitaddress.org-v3.3.0/bitaddress.org.html`
   2. Follow instructions to generate randomness
   3. Record the SECRET key in the password manager. This should stay offline until access to its content is required.
   4. The SHARE key should be kept in the password manager too, but can be share freely and used to deposit into. 
4. Generate Etherium ETH wallet
   1. Open Firefox and go to `file://home/user/eth/index.html`
   2. Click "Create Wallet", then "Software", then "Keystore File"
   3. Enter a password and click "Create Wallet", then "Acknoledge & Download" (a file will download)
   4. Click "Access Wallet", then "Software", then "Keystore"
   5. Click "Select File" then select the file you just downloaded
   6. Enter the password you just created and click "Access Wallet"
   7. Click the "hamburger button" in the top left of the screen, then use the "PORTFOLIO VALUE" dropdown to select "View paper wallet"
   8. Record the SECRET key in the password manager. This should stay offline until access to its content is required.
   9. The SHARE key should be kept in the password manager too, but can be share freely and used to deposit into. 

## Using the system
- To add a password: `pass insert Path/to/name`
- To use the password manager gui: `qtpass`
- To browe wikipedia: TODO

## Accessing cold wallets (online) 
1. Make sure to note any private keys used on the open internet. They are no longer totaly secure.
2. For Bitcion BTC:
   1. TODO
3. For Etherium ETH:
   1. TODO
