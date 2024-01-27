# paho-mqtt library
# username and key are hide in config.py, and not push to github
from adafruit_mqtt import Adafruit_MQTT
import config
import time
import random

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

# Test publish data to Adafruit IO every 5 seconds
counter_runtime = 35
counter_loop = 5
sensor_type = 1

while counter_runtime > 0:
    counter_runtime -= 1
    counter_loop -= 1

    if counter_loop == 0:
        counter_loop = 5
        if sensor_type == 1:
            value = random.randrange(-10, 50)
            khiem_client.publish(aio_sensor_ids[0], value)
            sensor_type = 2
        elif sensor_type == 2:
            value = random.randint(0, 500)
            khiem_client.publish(aio_sensor_ids[1], value)
            sensor_type = 3
        elif sensor_type == 3:
            value = random.randint(0, 100)
            khiem_client.publish(aio_sensor_ids[2], value)
            sensor_type = 1
    time.sleep(1)