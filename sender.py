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
pulse = pulseio.PulseOut(board.LED, frequency=38000, duty_cycle=32768)
#                             on   off     on    off    on
pulses = array.array('H', [65000, 1000, 65000, 65000, 1000])


# 50% duty cycle at 38kHz.
pulse2 = pulseio.PulseOut(board.GP15, frequency=38000, duty_cycle=32768)
#                             on   off     on    off    on
pulses2 = array.array('H', [65000, 1000, 65000, 65000, 1000])


    
    
while True:
    pulse.send(pulses)

    time.sleep(1)
    
    pulse2.send(pulses2)

    

print("done.")



