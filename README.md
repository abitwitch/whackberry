# whackberry
Offline and disconnected cyberdeck for password managment. 


# WhackberryPi
Disconnected Cyberdeck for password management

## Hardware
- Raspberry Pi Zero v1.3 [link](https://www.adafruit.com/product/2885)
- M5 CardKB (v1.1)
- HDMI 5" Display [link](https://www.adafruit.com/product/2232)
- Raspberry Pi Camera Module 3 [link](https://www.adafruit.com/product/5657)
- Thru-hole 5-way Navigation switch (used as a mouse) [link](https://www.adafruit.com/product/504)
- TODO: REMOVE AND REPLACE MicroSD card breakout board (x2) [link](https://www.adafruit.com/product/254)
- ATECC608 Breakout Board ([link](https://www.adafruit.com/product/4314)
- Infrared LED [link](https://www.adafruit.com/product/387)
- Infrared Receiver Sensor [link](https://www.adafruit.com/product/157)
- Raspberry Pi Pico (RP2040 - no wifi) [link](https://www.adafruit.com/product/5525)
- At least 1 micro CD card
- A Raspberry Pi with internet (for setup only)
- A USB A micro SD Card reader (Optional) [link](https://shop.sandisk.com/en-ca/products/accessories/memory-card-readers/sandisk-quickflow-microsd-usb-a-memory-card-reader?sku=SDDR-B731-GN6NN)

### PCB Mounting accessories
- SMD Grove Female Header [link](https://www.mouser.ca/ProductDetail/Seeed-Studio/114020164?qs=7MVldsJ5Uayw%2FOfizq4F8w%3D%3D)
- USB Type-A Jack [link](https://www.mouser.ca/ProductDetail/Amphenol-FCI/87583-0010BHLF?qs=HGI6s9c03KdFNxR4%2F7F3Vg%3D%3D)

## SD card setup
1. Download Official Raspberry Pi Imager
2. Select Legacy, 32-bit - Debian Bullseye (released 2024-10-22)
3. Flash the SD card and then access the files on the SD card
4. Set up the display
   1. Setup the display. Under `bootfs > config.txt`, add the following lines (more info [here](https://learn.adafruit.com/adafruit-5-800x480-tft-hdmi-monitor-touchscreen-backpack/raspberry-pi-config))
       ```
       hdmi_group=2
       hdmi_mode=87
       hdmi_cvt=800 480 60 6 0 0 0
       hdmi_drive=1
       max_usb_current=1
       ```
   2. Enable i2c. Under `bootfs > config.txt`, uncomment "dtparam=i2c_arm=on". Follow instructions [here](https://raspberrypi.stackexchange.com/questions/83457/can-i-enable-i2c-before-first-boot)

## Configure the OS
I suggest doing the configuartion from another pi with internet. Plug the SD card into a internet-connected Raspberry Pi and boot it. Follow the commands to set up your account and apply any updates. Reboot the device.

### Enable i2c (optional)
1. In terminal type, `sudo raspi-config`
2. `Interface Options > I2C > Yes  (enable) > OK > Finish`

### Turn on boot to terminal by default (optional)
1. In terminal type, `sudo raspi-config`
2. `System Options > Boot / Auto login > Console Autologin > Finish`
3. In subsequent boots, if you want a GUI, enter `startx` into the terminal

### Updrade all apps
- In teminal: `sudo apt update && sudo apt full-upgrade` (tried to see if would fix chromium on zero)
- Install circuit python: `sudo pip3 install --break-system-packages adafruit-blinka`
- Install PyUserInput for mouse: `sudo pip3 install PyUserInput pynput`

### CarKB setup
- Follow instructions [here](https://github.com/ian-antking/cardkb)
- *add `sudo` to `modprobe uinput`

### Camera Setup
- Just plug and play
- `libcamera-hello` to test
- `libcamera-jpeg -o /path/to/file.jpg` to take a picture

### Set up 5-way navi mouse
Wiring
1. Connect 3.3v output from the Raspberri Pi to the common pin. For me, the was the pin farthest from the little "L" on the back of the switch
2. Connect 10k ohm resesistors to all the remaining pins and attatch to GPIO pins on the PI
Software
1. 'sudo nano /etc/xdg/lxsession/LXDE-pi/autostart`
2. Add this line to the end of the file, then save and exit: `@/home/user/navmouse/mouselauncher.sh`
3. `mkdir /home/user/navmouse`
4. Copy `mouse.py` and `navmouselauncher.sh` to `/home/user/navmouse`
5. `sudo chmod +x /home/user/navmouse/*`

### Infrared Transmitter
1. Create a RAM disk for storing output:
   1. Add `newramdisk  /mnt/ramdisk  tmpfs  rw,size=1M  0   0` to `/etc/fstab``mkdir /home/user/ir-sender`
2. Copy `ir-sender` to the folder `/home/user/ir-sender`
3. `chmod +x /home/user/ir-sender`
4. Add these lines `/home/user/.profile`
   ```
   if [ -d "$HOME/ir-sender" ] ; then
   PATH="$PATH:$HOME/ir-sender"
   fi
   ```
6. Generate new key: `ir-sender --genkey`
7. Copy the contents of the json and use it when setting up the Infrared Reciever

### Infrared Reciever
This part of the device is on an isolated device that emulates a keyboard when plugged into the computer.
On a PC connected to the Pico
1. Download circuit python for the QTPy RP2040 ([link](https://circuitpython.org/board/adafruit_qtpy_rp2040/)) (I used CircuitPython 9.2.6)
2. Download the circuit python bundle ([link](https://github.com/adafruit/Adafruit_CircuitPython_Bundle/releases/tag/20250319)) (I used 'March 19, 2025 auto-release')
3. While holding down the `BOOT` button on the QTPy, connect it to the PC.
4. Copy the "uf2" file you downloaded in step 1 to the device. You should see `INDEX.HTM` and `INFO_UF2.TXT` there already. Wait for the device to reboot.
5. Unzip the folder from step 2 and copy the following folders and file to the `lib` folder of the QTPy.
   `adafruit_hid`, `adafruit_pixelbuf.mpy`, `neopixel.mpy`, `adafruit_rsa`, `adafruit_logging.mpy`, `adafruit_binascii`, `adafruit_hashlib` 
8. Copy the contents of the `ir-receiver-code.py` to `code.py`
9. Create a new file at the top level called `private_key.json` and put the json contents in it generated when setting up the Infrared Transmitter


TODO
- PCB: add holes for cable mgnt
- PCB: finalize and order
- Commandline crypto wallet
- Nice to have: ir-sender GUI using tkinter


















## Start system init (online) 
1. Download the Raspberry Pi Imager from [here](https://www.raspberrypi.com/software/)
2. Select latest Operating System with decktop support. At writing this, is was "Raspberry Pi OS with desktop (Debian version: 12 - bookworm)"
3. Choose an SD card and write to it. 
4. Install password manager
   1. `sudo apt-get install pass`
   2. `sudo apt-get install qtpass`
   3. `sudo apt-get install ninvaders`
5. Install Bitcoin BTC Offline Key Generator
   1. `mkdir /home/user/btc`
   2. `cd /home/user/btc`
   3. `wget https://github.com/pointbiz/bitaddress.org/archive/refs/tags/v3.3.0.zip`
   4. `unzip bitaddress.org-v3.3.0.zip`
6. Install Etherium ETH Offline Key Generator
   1. `mkdir /home/user/eth`
   2. `cd /home/user/eth`
   3. `wget https://github.com/MyEtherWallet/MyEtherWallet/releases/download/v6.9.17/MyEtherWallet-v6.9.17-Offline.zip` (get latest version)
   4. `unzip MyEtherWallet-v6.9.17-Offline.zip`
7. Download reference material
   1. `mkdir /home/user/referencepages`
   2. `cd /home/user/referencepages`
   3. Download a pdf of `https://www.bitcoin.com/get-started/setting-up-your-own-cold-storage-bitcoin-wallet/`
   4. Download a pdf of `https://help.myetherwallet.com/en/articles/6512619-using-mew-offline/`
   5. Download a pdf of `https://help.myetherwallet.com/en/articles/6167899-how-to-create-a-cold-wallet-a-k-a-paper-wallet`
8. Download wikipedia
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
   1. You can use any wallet that supports importing private keys to access the BTC. I'll include instructions for Electrum (v4.5.8) below.
   2. Download and install the application. Be very careful to download from the offical page (https://electrum.org/#download)[https://electrum.org/#download]
   3. Open the application and when prompted, select "Import Bitcoin addresses or private keys"
   4. Enter the private key for Bitcoin BTC.
   5. You can use the "Send" tab to send to any address. Start with a small amount to make sure everything is working.
3. For Etherium ETH:
   1. You can use any wallet that supports importing private keys to access the BTC. I'll include instructions for MetaMask Firefox Extension (v12.6.2) below.
   2. Go to MetaMask's site. Be sure it's the official source: [https://metamask.io/download/](https://metamask.io/download/)
   3. Download and lauch the extension
   4. Follow the propmts and select "create new wallet"
   5. Once on the main account page, click the account dropdown at the top of the screen
   6. Select "Add account or hardware wallet" then "Import account"
   7. Enter the private key for Etherium ETH.
   8. You can use the "Send" button to send to any address. Start with a small amount to make sure everything is working.
