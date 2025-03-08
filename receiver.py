#Pico IR reciever
import board
import pulseio
import time


print("start.")
pulses = pulseio.PulseIn(board.GP15, maxlen=200, idle_state=True)

pulse_min=1000
pulse_increment=500
pulse_checksum=0
bytedata = bytearray()

'''
def decodePulses(receivedPulses):
    

    
    s = ""
    nulled=False
    for pulse in receivedPulses:
        byte=(pulse-pulse_min)/pulse_increment
        byte=round(byte)
        if byte>255:
            raise ValueError("Error: unknown pulse length")
        if nulled:
            pass
            #if pulse_checksum!=byte:
            #    raise ValueError("Error: bad checksum")
        else:
            pulse_checksum=(pulse_checksum+byte)%256
            s+=chr(byte)
        if byte=='\0':
            nulled=True
    print(s)
    return s
'''    
def decodeBytes(bytedata):
    sendKeystrokes(bytedata.decode("utf-8"))

def sendKeystrokes(string):
    print(string)
    #TODO

while True:
    s=[]
    while len(pulses)>0:
        pulse=pulses.popleft()
        byte=(pulse-pulse_min)/pulse_increment
        byte=round(byte)
        if byte>255:
            byte-=2*((255*pulse_increment)+pulse_min) #minus 2xfull bytes
            if pulse_checksum!=byte:
                raise ValueError("Error: bad checksum")
            else:
                decodeBytes(bytedata)
                pulse_checksum=0
                bytedata = bytearray()
        else:
            pulse_checksum=(pulse_checksum+byte)%256
            bytedata.append(byte)
    time.sleep(1)
    
print("done.")

