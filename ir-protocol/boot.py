import time
import board
import digitalio
import storage

# Initialize the button on GP15 or A0 on QT Py RP2040 with an internal pull-up resistor
button = digitalio.DigitalInOut(board.A0)
button.switch_to_input(pull=digitalio.Pull.UP)

# Variable to track if the button was pressed
button_pressed = False

# Start timing
start_time = time.monotonic()

# Wait for up to 3 seconds to check if the button is pressed
while time.monotonic() - start_time < 3:
    if not button.value:
        # Button is pressed (active low)
        button_pressed = True
        break  # Exit the loop early if the button is pressed
    time.sleep(0.1)  # Small delay to reduce CPU usage

# If the button was not pressed during the 3-second window, disable the USB drive
if not button_pressed:
    print("button not pressed, usb drive disabled.")
    storage.disable_usb_drive()
else:
    print("buton pressed, mounting usb drive")

