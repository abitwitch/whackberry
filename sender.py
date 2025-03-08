#Pico IR reciever
import board
import time
import array
import pulseio

# 50% duty cycle at 38kHz.
pulseLED = pulseio.PulseOut(board.LED, frequency=38000, duty_cycle=32768)
# 50% duty cycle at 38kHz.
pulseIR = pulseio.PulseOut(board.GP14, frequency=38000, duty_cycle=32768)

#Allows for unique 258 pulses
#0-255: data
#256: start data stream
#257: end stream
#258: unused
pulse_min=1000
pulse_increment=250

def text_to_bytearray(text):
    #todo add crypt
    bytedata = bytearray()
    bytedata.extend(text)
    return(bytedata)

def bytearray_to_pulsearray(bytearray: bytedata):    
    pulse_checksum=0
    pulses = array.array('H')
    startStreamPulse=(256*pulse_increment)+pulse_min #max byte+1
    pulses.append(startStreamPulse)
    for byte in bytedata:
        pulse_checksum=(pulse_checksum+byte)%256
        byte=(byte*pulse_increment)+pulse_min
        pulses.append(byte)
    endStreamPulse=(257*pulse_increment)+pulse_min #max byte+2
    checksumPulse=(pulse_checksum*pulse_increment)+pulse_min
    pulses.append(endStreamPulse)
    pulses.append(checksumPulse)
    pulses.append(endStreamPulse) #extra pulse seems to be needed for a clean array to be received by reveiver
    return(pulses)

text="hello world"
bytedata=text_to_bytearray(text)
pulses=bytearray_to_pulsearray(bytedata)

while True:
    time.sleep(0.5)
    
    pulseLED.send(pulses)

    time.sleep(0.5)
    
    pulseIR.send(pulses)


