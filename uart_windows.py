import serial.tools.list_ports

def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "serial port" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
            break
    return commPort

def processData(client, data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    print(splitData)
    if splitData[1] == "T": # T refers to temperature
        client.publish("sensor1", splitData[2])
    elif splitData[1] == "H": # H refers to humidity
        client.publish("sensor2", splitData[2])
    elif splitData[1] == "L": # L refers to light
        client.publish("sensor3", splitData[2])

mess = ""
# Message in form: !1:<type>:<value>#
def readSerial(client):
    bytesToRead = ser.inWaiting()
    if (bytesToRead > 0):
        global mess
        mess = mess + ser.read(bytesToRead).decode("UTF-8")
        print("Get uart message: " + mess)
        while ("#" in mess) and ("!" in mess):
            start = mess.find("!")
            end = mess.find("#")
            processData(client, mess[start:end + 1])
            if (end == len(mess)):
                mess = ""
            else:
                mess = mess[end+1:]

# Open the serial port
if getPort() != "None":
    ser = serial.Serial(port=getPort(), baudrate=115200)
    print(ser)