#Pico IR reciever
import board
import pulseio
import time
import neopixel
import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keyboard_layout_us import KeyboardLayoutUS

#Encryption params
crypt_enctrypred=True
crypt_key_size=512
crypt_max_message_len=int(crypt_key_size/8)
if crypt_enctrypred:
  import adafruit_rsa
  import json
  with open("privatekey.json","r") as f:
    pk_json=json.loads(f.read())
  private_key=adafruit_rsa.key.PrivateKey(pk_json["n"],pk_json["e"],pk_json["d"],pk_json["p"],pk_json["q"])

print("start.")
pulses = pulseio.PulseIn(board.MOSI, maxlen=200, idle_state=True)
pixel = neopixel.NeoPixel(board.NEOPIXEL, 1)

kbd = Keyboard(usb_hid.devices)
layout = KeyboardLayoutUS(kbd)

#Allows for n unique pulse lengths
#0: start data stream
#1: end stream
#2: start instructions
#3 to n: data
pulses_per_byte=2
if not pulses_per_byte in [1,2,4,8]:
  raise ValueError(f"Error: can not split a byte into {pulses_per_byte} parts.")
bits_per_pulse=int(8/pulses_per_byte)
n=int(256/pulses_per_byte)+3
pulse_min=1000
pulse_max=(2**16)-pulse_min
#special pulses
start_val=0
end_val=1
inst_val=2
minData_val=3
pulse_increment=(pulse_max-pulse_min)/(n+3)
timeout=10 #how many seconds (or part of) with nothing recieved before timeout
lastrecieved=-1

checksum=checksum_ver=0
byte_part=byte=0
bytedata = bytearray()
stream_status="ready"
packet_status="ready"

def bytearray_to_text(bytedata):   
  return(bytedata.decode("utf-8"))

def decrypt_bytes(bytedata):
  decrypted_bytedata = bytearray()
  c=0
  while c<(len(bytedata)/crypt_max_message_len):
    fromindex=c*crypt_max_message_len
    c+=1
    toindex=min(len(bytedata),c*crypt_max_message_len)
    decrypted_bytedata.extend(adafruit_rsa.decrypt(bytes(bytedata[fromindex:toindex]),private_key))
  return(decrypted_bytedata)
  
def flashcolours(colours,flash_duration,total_duration):
  for i in range(int(total_duration/flash_duration)):
    colour=colours[i%len(colours)]
    pixel.fill(colour)
    time.sleep(flash_duration)
  
def sendKeystrokes(string):
  layout.write(string)
      
while True:
  #set LED
  if packet_status=="receiving":
    pixel.fill((255, 165, 0)) #Orange
  else:
    pixel.fill((0, 0, 0))
  #check for timeout
  if stream_status!="ready" and time.time()-lastrecieved > timeout:
    print("Error: signal timeout.")
    flashcolours([(0, 0, 0),(255, 0, 0)],0.4,2) #Off and Red
    packet_status="ready"
    stream_status="ready"
    checksum=checksum_ver=0
    byte_part=byte=0
    bytedata = bytearray()
    lastrecieved = -1
  #read pulse
  while len(pulses)>0:
    lastrecieved=time.time()
    pulse=pulses.popleft()
    pulse_val=(pulse-pulse_min)/pulse_increment
    pulse_val=round(pulse_val)
    if pulse_val==start_val and stream_status=="ready" and packet_status=="receiving":
      stream_status="datastream"
    elif pulse_val==inst_val:
      if packet_status=="ready":
        stream_status="instruction"
      if packet_status=="receiving":
        stream_status="checksum"
    elif pulse_val==end_val:
      if stream_status=="instruction":
        #prepare new stream
        packet_status="receiving"
        stream_status="ready"
        checksum=checksum_ver=0
        byte_part=byte=0
        bytedata = bytearray()
      elif stream_status=="checksum":
        #finsih current stream
        if checksum==checksum_ver and len(bytedata)!=0:
          if crypt_enctrypred:
            pixel.fill((0,0,255)) #Blue
          else:
            pixel.fill((0, 165, 0)) #Green
          decrypt_failed=False
          if crypt_enctrypred:
            try:
              bytedata=decrypt_bytes(bytedata)    
            except:
              print("Error: decrypt failed. Check public and private keys.")
              flashcolours([(0,0,255),(255, 0, 0)],0.4,2) #Blue and Red
              decrypt_failed=True
          if not decrypt_failed:
            try:
              text=bytearray_to_text(bytedata)
              sendKeystrokes(text)
              pixel.fill((0, 165, 0)) #Green
              time.sleep(1) #keep green and pause any other actions for a short time
            except:
              print("Error: unable to decode or send keys. Check input text.")
              flashcolours([(255, 0,165),(255, 0, 0)],0.4,2) #Pink and Red
        else:
          flashcolours([(255, 165, 0),(255, 0, 0)],0.4,2) #Orange and Red
          print("Error: bad checksum, exiting data stream.")        
        packet_status="ready"
        stream_status="ready"
        checksum=checksum_ver=0
        byte_part=byte=0
        bytedata = bytearray()
        lastrecieved = -1
      else:
        #prepare for new packet
        stream_status="ready"
    elif 0 > pulse_val > n:
      print("Warning: unexpected pulse length, ignoring pulse.")
    elif stream_status in ["datastream","checksum"] and packet_status=="receiving":
      pulse_val-=3  #for the 3 special values
      byte+=pulse_val<<(bits_per_pulse*byte_part)
      byte_part+=1
      if byte_part==pulses_per_byte:
        if stream_status=="checksum":
          checksum_ver=byte
        if stream_status=="datastream" and byte in range(0,256):
          bytedata.append(byte)
          checksum=(checksum+byte)%256
        byte_part=byte=0
    else:
      pass #this is where any unexpected values or padding values used to buffer packets will end up. They can be ignored.


