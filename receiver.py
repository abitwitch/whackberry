#Pico IR reciever
import board
import pulseio
import time


print("start.")
pulses = pulseio.PulseIn(board.GP15, maxlen=200, idle_state=True)



while True:
    s=[]
    while len(pulses)>0:
        s.append(pulses.popleft())
    print(s)
    time.sleep(1)
    
print("done.")

