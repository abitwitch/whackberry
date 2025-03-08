#Pico IR reciever
import board
import pulseio
import time

print("start.")
pulses = pulseio.PulseIn(board.GP15, maxlen=200, idle_state=True)

pulse_min=1000
pulse_increment=250
pulse_checksum=0
bytedata = bytearray()
status="ready"

def bytearray_to_text(bytedata):
    #todo add crypt
    return(bytedata.decode("utf-8"))

def sendKeystrokes(string):
    print(string)
    #TODO

while True:
    while len(pulses)>0:
        pulse=pulses.popleft()
        byte=(pulse-pulse_min)/pulse_increment
        byte=round(byte)
        if byte==256:
            status="datastream"
            pulse_checksum=0
            bytedata=bytearray()
        elif byte>256:
            status="checksum"
        elif byte<0:
            status="error"
            print("Warning: unexpected pulse length")
        elif status=="datastream":
            pulse_checksum=(pulse_checksum+byte)%256
            bytedata.append(byte)
        elif status=="checksum":
            if pulse_checksum!=byte:
                print("Error: bad checksum")
            else:
                text=bytearray_to_text(bytedata)
                sendKeystrokes(text)
            status="ready"
    #time.sleep(1)
    
print("done.")

