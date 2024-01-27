import sys
from Adafruit_IO import MQTTClient

class Adafruit_MQTT:
    # CLASS VARIABLES
    # Variables
    __AIO_FEED_IDs = None
    __AIO_USERNAME = None
    __AIO_KEY = None
    __client = None
    
    # Callback function for message
    callBackFunc = None

    # CLASS METHODS
    # Getters
    def getAllFeedIDs(self):
        return self.__client.feeds()
    def getAIOFeedIDs(self):
        return self.__AIO_FEED_IDs
    def getAIOUsername(self):
        return self.__AIO_USERNAME
    def getAIOKey(self):
        return self.__AIO_KEY
    
    # Setters
    def setAIOFeedIDs(self, aio_feed_ids):
        self.__AIO_FEED_IDs = aio_feed_ids
    def setAIOUsername(self, username):
        self.__AIO_USERNAME = username
    def setAIOKey(self, key):
        self.__AIO_KEY = key
    def setCallBackFunc(self, callBackFunc):
        self.callBackFunc = callBackFunc
    
    # Callback functions for 4 events
    def connected(self, client):
        # This will be called when the client connects.
        print("Notification: Connected Successfully!")
        for feed in self.__AIO_FEED_IDs:
            client.subscribe(feed)
    def subscribe(self, client , userdata , mid , granted_qos):
        # This will be called when the client subscribes to a new feed.
        print("Notification: Subscribed to feed: " + str(mid) + ", QoS " + str(granted_qos))
    def message(self, client , feed_id , payload):
        # This will be called when a message is received.
        print("Notification: Received: " + payload + " from " + feed_id)
        if self.callBackFunc != None:
            self.callBackFunc(feed_id, payload)
    def disconnected(self, client):
        # This will be called when the client disconnects.
        print("Notification: Disconnected from Adafruit IO!")
        sys.exit(1)

    # Constructor
    def __init__(self, username, key, aio_feed_ids, callBackFunc = None):
        # Only setup parameters
        self.__AIO_FEED_IDs = aio_feed_ids
        self.__AIO_USERNAME = username
        self.__AIO_KEY = key
        self.callBackFunc = callBackFunc

    def setup(self):
        # Create an MQTT client instance.
        self.__client = MQTTClient(self.__AIO_USERNAME , self.__AIO_KEY)

        # Setup the callback functions
        self.__client.on_connect = self.connected
        self.__client.on_subscribe = self.subscribe
        self.__client.on_message = self.message
        self.__client.on_disconnect = self.disconnected
    
    def connect_and_loop(self):
        self.__client.connect()
        self.__client.loop_background()

    def publish(self, feed_id, value):
        # This will send "value" to the feed "feed_id".
        self.__client.publish(feed_id, value)