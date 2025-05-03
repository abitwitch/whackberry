import time
from pynput.mouse import Button, Controller
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
speed=5 #1-10
leftPin=15
rightPin=23
upPin=19
downPin=13
centerPin=21
rightclickPin=27
GPIO.setup(leftPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(rightPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(upPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(downPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(centerPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(rightclickPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

centerPin_prevval=GPIO.input(centerPin)==GPIO.HIGH
rightclick_prevval=GPIO.input(rightclick)==GPIO.HIGH
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
    mouse.move(0,-1)
  if GPIO.input(downPin)==GPIO.HIGH:
    mouse.move(0,1)
  centerPin_curval=GPIO.input(centerPin)==GPIO.HIGH
  if centerPin_curval!=centerPin_prevval:
    centerPin_prevval=centerPin_curval
    if centerPin_curval:
      mouse.click(Button.left)
  rightclickPin_curval=GPIO.input(rightclickPin)==GPIO.HIGH
  if rightclickPin_curval!=rightclick_prevval:
    rightclick_prevval=rightclickPin_curval
    if rightclick_prevval:
      mouse.click(Button.right)
  time.sleep(0.001/speed)
 
 


 
 
