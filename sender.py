#Pico IR reciever
import time
import board
import digitalio
import time
import board

import array
import pulseio

'''
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT


for x in range(2):
    led.value = True
    time.sleep(0.5)
    led.value = False
    time.sleep(0.5)

import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode



print("start.")

# Set up a keyboard device.
kbd = Keyboard(usb_hid.devices)
'''

# 50% duty cycle at 38kHz.
pulseLED = pulseio.PulseOut(board.LED, frequency=38000, duty_cycle=32768)
# 50% duty cycle at 38kHz.
pulseIR = pulseio.PulseOut(board.GP14, frequency=38000, duty_cycle=32768)

text="hello world"

pulse_min=1000
pulse_increment=500

pulse_checksum=0
pulses = array.array('H')
bytedata = bytearray()
bytedata.extend(text)
for byte in bytedata:
    pulse_checksum=(pulse_checksum+byte)%256
    byte=(byte*pulse_increment)+pulse_min
    pulses.append(byte)
finalPulse=(255*pulse_increment)+pulse_min #max byte
finalPulse*=2 #double
finalPulse+=pulse_checksum #with checksum
pulses.append(finalPulse)    
    
    
while True:
    pulseLED.send(pulses)

    time.sleep(1)
    
    pulseIR.send(pulses)

    

print("done.")



