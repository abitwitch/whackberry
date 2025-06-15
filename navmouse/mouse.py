import time
from pynput.mouse import Button, Controller
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
time_wait=0.1
max_speed=25 #pixels per time wait
leftPin=15
rightPin=23
upPin=19
downPin=13
centerPin=21
rightclickPin=29
GPIO.setup(leftPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(rightPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(upPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(downPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(centerPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(rightclickPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

centerPin_prevval=GPIO.input(centerPin)==GPIO.HIGH
rightclick_prevval=GPIO.input(rightclickPin)==GPIO.HIGH
mouseReady=False
moving_streak=0
prevInput=0
while True:
  if not mouseReady:
    try:
      mouse=Controller()
      mouseReady=True
    except:
      time.sleep(2)
      continue
  moving=False
  pixels_to_move=1+min(max_speed,int(moving_streak*time_wait*2))
  if GPIO.input(leftPin)==GPIO.HIGH:
    mouse.move(-pixels_to_move,0)
    moving=True
  if GPIO.input(rightPin)==GPIO.HIGH:
    mouse.move(pixels_to_move,0)
    moving=True
  if GPIO.input(upPin)==GPIO.HIGH:
    mouse.move(0,-pixels_to_move)
    moving=True
  if GPIO.input(downPin)==GPIO.HIGH:
    mouse.move(0,pixels_to_move)
    moving=True
  if moving:
    moving_streak+=1
  else:
    moving_streak=0
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
  time.sleep(time_wait)
 
 


 
 
