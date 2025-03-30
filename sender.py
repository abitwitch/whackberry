#Pico IR sender
import board
import time
import array
import pwmio
import pigpio
import os

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
pulse_increment=round((pulse_max-pulse_min)/(n+3))
#pulses per packet
packet_size=11 #limitation of ir-ctl

startStreamPulse=(start_val*pulse_increment)+pulse_min
endStreamPulse=(end_val*pulse_increment)+pulse_min
instructionPulse=(inst_val*pulse_increment)+pulse_min
minDataPulse=(3*pulse_increment)+pulse_min

basefilepath="/mnt/ramdisk/packet"

def text_to_bytearray(text):
  #todo add crypt
  bytedata = bytearray()
  bytedata.extend(map(ord, text))
  return(bytedata)

def bytearray_to_pulsepacket(bytedata: bytearray, instruction=False):    
  pulses = []
  pulses.append(minDataPulse) #extra pulse seems to be needed for a clean array to be received by reveiver
  if instruction:
    pulses.append(instructionPulse)
  else:
    pulses.append(startStreamPulse)
  for byte in bytedata:
    pulse=(byte*pulse_increment)+minDataPulse
    pulses.append(pulse)
  pulses.append(endStreamPulse)
  pulses.append(minDataPulse) #extra pulse seems to be needed for a clean array to be received by reveiver
  if len(pulses)%2==0:
    pulses.append(minDataPulse) #make sure there is an even number of pulses (on and off)
  return(pulses)

def pulses_to_file(pulses, packetnum):
  strToWrite=""
  pulseOn=True
  for pulse in pulses:
    if pulseOn:
      strToWrite+="+"
    else:
      strToWrite+="-"
    pulseOn=not pulseOn
    strToWrite+=str(pulse) + " "
  strToWrite=strToWrite.strip()
  filepath=basefilepath+str(packetnum)
  with open(filepath,"w") as f:
    f.write(strToWrite)
    
def split_bytes(bytedata):
  bytedata_mod=[]#bytearray()
  byte_part=int(256/pulses_per_byte)-1
  for byte in bytedata:
    full_parts=int(byte/byte_part)
    remainer_part=byte%byte_part
    zero_parts=pulses_per_byte-full_parts-1
    bytedata_mod.extend([byte_part]*full_parts)
    bytedata_mod.append(remainer_part)
    bytedata_mod.extend([0]*zero_parts)    
  return(bytedata_mod)
  
def split_bytes(bytedata):
  bytedata_mod=[]#bytearray()
  bits_per_pulse=int(8/pulses_per_byte)
  for byte in bytedata:
    for i in range(int(8/bits_per_pulse)-1):
      byte_part=byte>>(bits_per_pulse*i)
      bytedata_mod.append(byte_part)
    bytedata_mod.append(byte^byte_part)
    #a=byte>>bits_per_pulse
    #b=byte^a 
  return(bytedata_mod)

def split_bytes(bytedata):
  bytedata_mod=bytearray()
  for byte in bytedata:
    bytedata_mod.extend(split_byte(byte))
  return(bytedata_mod)

def split_byte(byte):
  byte_parts=bytearray()
  mask=0
  for i in range(pulses_per_byte):
    #bit mask
    mask=((2**((i+1)*bits_per_pulse))-1)-mask
    byte_part=byte&mask
    #bit shift
    shift=bits_per_pulse*i
    byte_part=byte_part>>shift
    byte_parts.append(byte_part)
  return(byte_parts)
  
def send_data_stream(bytedata):
  #first packet
  packetnum=0
  firstpacket_bytedata=bytearray()
  pulses=bytearray_to_pulsepacket(firstpacket_bytedata, True)
  pulses_to_file(pulses,packetnum)
  #split up vals in bytedata
  checksum=sum(bytedata)%256
  bytedata=split_bytes(bytedata)
  #body packet(s)
  c=0
  while c<(len(bytedata)/packet_size):
    fromindex=c*packet_size
    c+=1
    toindex=min(len(bytedata),c*packet_size)
    pulses=bytearray_to_pulsepacket(bytedata[fromindex:toindex])
    #packetnum=c
    pulses_to_file(pulses,c)
  #split up vals in checksum
  checksum_bytedata=split_bytes(bytearray([checksum]))
  #last packet
  packetnum=c+1
  lastpacket_bytedata=checksum_bytedata
  pulses=bytearray_to_pulsepacket(lastpacket_bytedata, True)
  pulses_to_file(pulses,packetnum)
  #send all files
  send_files(packetnum+1)

def send_files(packetcnt):
  cmd="ir-ctl "
  for packetnum in range(packetcnt):
    cmd+=f"--send {basefilepath+str(packetnum)} "
  cmd=cmd.strip()
  os.system(cmd)
  #cleanup
  os.system("rm /mnt/ramdisk/packet*")
  time.sleep(0.1)

text="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
#text="ab"
bytedata=text_to_bytearray(text)

while True:
  send_data_stream(bytedata)
  time.sleep(3)
