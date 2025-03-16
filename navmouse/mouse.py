import time
from pynput.mouse import Button, Controller
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
leftPin=13
rightPin=15
upPin=19
downPin=21
centerPin=23
GPIO.setup(leftPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(rightPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(upPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(downPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(centerPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

centerPin_prevval=GPIO.input(centerPin)==GPIO.HIGH
mouseReady=False
while True:
  if not mouseReady:
    try:
      mouse=Controller()
      mouseReady=True
    except:
      time.sleep(2)
      continue
  if GPIO.input(leftPin)==GPIO.HIGH:
    mouse.move(-1,0)
  if GPIO.input(rightPin)==GPIO.HIGH:
    mouse.move(1,0)
  if GPIO.input(upPin)==GPIO.HIGH:
    mouse.move(0,1)
  if GPIO.input(downPin)==GPIO.HIGH:
    mouse.move(0,-1)
  centerPin_curval=GPIO.input(centerPin)==GPIO.HIGH
  if centerPin_curval!=centerPin_prevval:
    centerPin_prevval=centerPin_curval
    if centerPin_curval:
      mouse.click(Button.left)
  time.sleep(0.01)
 
 


 
 
