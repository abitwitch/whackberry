#Pico IR reciever
import board
import pulseio
import time

print("start.")
pulses = pulseio.PulseIn(board.GP3, maxlen=200, idle_state=True)

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
#pulses per packet
packet_size=10 #limitation of ir-ctl

checksum=checksum_ver=0
byte_part=byte=0
bytedata = bytearray()
stream_status="ready"
packet_status="ready"


def bytearray_to_text(bytedata):
  #todo add crypt
  return(bytedata.decode("utf-8"))

def sendKeystrokes(string):
  print(string)
  #TODO
      
while True:
  while len(pulses)>0:
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
        bytedata = bytearray()
      elif stream_status=="checksum":
        if checksum==checksum_ver:
          bytearray_to_text(bytedata)
        else:
          print("Error: bad checksum, exiting data stream.")
        checksum=checksum_ver=0
        bytedata = bytearray()
        packet_status="ready"
        stream_status="ready"
      else:
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
        if stream_status=="datastream":
          bytedata.append(byte)
          checksum=(checksum+byte)%256
        byte_part=byte=0
    else:
      pass #this is where any unexpected values or padding values used to buffer packets will end up. They can be ignored.

  time.sleep(1)
  
print("done.")

