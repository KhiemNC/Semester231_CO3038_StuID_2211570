# paho-mqtt library
# username and key are hide in config.py, and not push to github
from adafruit_mqtt import Adafruit_MQTT
import config
import time
from uart_windows import *

# FUNCTION DEFINITIONS
def callBackFunc_Message(feed_id, payload):
    print("Feed: " + feed_id + " - Value: " + payload)
    print("          or do something else...")

# MAIN PROGRAM
# Create an instance of Adafruit_MQTT class
username = config.username
key = config.key
aio_feed_ids = ["button1", 	"button2"]
aio_sensor_ids = ["sensor1", "sensor2", "sensor3"]
khiem_client = Adafruit_MQTT(username, key, aio_feed_ids, callBackFunc_Message)
khiem_client.setup()
khiem_client.connect_and_loop()

while True:
    readSerial(khiem_client)
    time.sleep(1)