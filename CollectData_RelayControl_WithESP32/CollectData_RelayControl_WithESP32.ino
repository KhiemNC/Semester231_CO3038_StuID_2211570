#include "DHT.h"
#include "WiFi.h"
#include "WiFiClientSecure.h"
#include "Adafruit_MQTT.h"
#include "Adafruit_MQTT_Client.h"

#define DHT_PIN       27
#define DHT_TYPE      DHT11

#define BUTTON1_PIN   19
#define BUTTON2_PIN   18

#define SSID1         "hidden"
#define PASSWORD1     "hidden"

#define SSID2         "hidden"
#define PASSWORD2     "hidden"

#define AIO_SERVER    "io.adafruit.com"
#define AIO_SVPORT    8883
#define AIO_USERNAME  "hidden"
#define AIO_KEY       "hidden"

WiFiClientSecure client;
Adafruit_MQTT_Client mqtt(&client, AIO_SERVER, AIO_SVPORT, AIO_USERNAME, AIO_KEY);
const char* adafruitio_root_ca = \
      "-----BEGIN CERTIFICATE-----\n"
      "MIIEjTCCA3WgAwIBAgIQDQd4KhM/xvmlcpbhMf/ReTANBgkqhkiG9w0BAQsFADBh\n"
      "MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3\n"
      "d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBH\n"
      "MjAeFw0xNzExMDIxMjIzMzdaFw0yNzExMDIxMjIzMzdaMGAxCzAJBgNVBAYTAlVT\n"
      "MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j\n"
      "b20xHzAdBgNVBAMTFkdlb1RydXN0IFRMUyBSU0EgQ0EgRzEwggEiMA0GCSqGSIb3\n"
      "DQEBAQUAA4IBDwAwggEKAoIBAQC+F+jsvikKy/65LWEx/TMkCDIuWegh1Ngwvm4Q\n"
      "yISgP7oU5d79eoySG3vOhC3w/3jEMuipoH1fBtp7m0tTpsYbAhch4XA7rfuD6whU\n"
      "gajeErLVxoiWMPkC/DnUvbgi74BJmdBiuGHQSd7LwsuXpTEGG9fYXcbTVN5SATYq\n"
      "DfbexbYxTMwVJWoVb6lrBEgM3gBBqiiAiy800xu1Nq07JdCIQkBsNpFtZbIZhsDS\n"
      "fzlGWP4wEmBQ3O67c+ZXkFr2DcrXBEtHam80Gp2SNhou2U5U7UesDL/xgLK6/0d7\n"
      "6TnEVMSUVJkZ8VeZr+IUIlvoLrtjLbqugb0T3OYXW+CQU0kBAgMBAAGjggFAMIIB\n"
      "PDAdBgNVHQ4EFgQUlE/UXYvkpOKmgP792PkA76O+AlcwHwYDVR0jBBgwFoAUTiJU\n"
      "IBiV5uNu5g/6+rkS7QYXjzkwDgYDVR0PAQH/BAQDAgGGMB0GA1UdJQQWMBQGCCsG\n"
      "AQUFBwMBBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMDQGCCsGAQUFBwEB\n"
      "BCgwJjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEIGA1Ud\n"
      "HwQ7MDkwN6A1oDOGMWh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEds\n"
      "b2JhbFJvb3RHMi5jcmwwPQYDVR0gBDYwNDAyBgRVHSAAMCowKAYIKwYBBQUHAgEW\n"
      "HGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwDQYJKoZIhvcNAQELBQADggEB\n"
      "AIIcBDqC6cWpyGUSXAjjAcYwsK4iiGF7KweG97i1RJz1kwZhRoo6orU1JtBYnjzB\n"
      "c4+/sXmnHJk3mlPyL1xuIAt9sMeC7+vreRIF5wFBC0MCN5sbHwhNN1JzKbifNeP5\n"
      "ozpZdQFmkCo+neBiKR6HqIA+LMTMCMMuv2khGGuPHmtDze4GmEGZtYLyF8EQpa5Y\n"
      "jPuV6k2Cr/N3XxFpT3hRpt/3usU/Zb9wfKPtWpoznZ4/44c1p9rzFcZYrWkj3A+7\n"
      "TNBJE0GmP2fhXhP1D/XVfIW/h0yCJGEiV9Glm/uGOa3DXHlmbAcxSyCRraG+ZBkA\n"
      "7h4SeM6Y8l/7MBRpPCz6l8Y=\n"
      "-----END CERTIFICATE-----\n";

Adafruit_MQTT_Publish sensor1 = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/sensor1");
Adafruit_MQTT_Publish sensor2 = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/sensor2");
Adafruit_MQTT_Publish sensor3 = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/sensor3");
Adafruit_MQTT_Subscribe button1 = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/button1");
Adafruit_MQTT_Subscribe button2 = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/button2");

DHT dht(DHT_PIN, DHT_TYPE);
int8_t publishSensor = 1;

float lTemp = -1;
float lHumid = -1;
float lHeatIdx = -1;

void setup() {
  Serial.begin(115200);

  pinMode(BUTTON1_PIN, OUTPUT);
  pinMode(BUTTON2_PIN, OUTPUT);

  client.setCACert(adafruitio_root_ca);

  button1.setCallback(button1_callback);
  button2.setCallback(button2_callback);
  // Setup MQTT subscription for button
  Serial.println("Set up: Subcribe button!");
  mqtt.subscribe(&button1);
  mqtt.subscribe(&button2);
  Serial.println("Set up: Done Subcribe button!");

  dht.begin();
}

void loop() {
  Serial.println("New sesion!");
  WiFi_connect();
  MQTT_connect();
  publishData();
  mqtt.processPackets(3000);  
}

void WiFi_connect() {
  if (WiFi.status() == WL_CONNECTED) return;

  Serial.print("Connecting to ");
  Serial.print(SSID1);

  WiFi.begin(SSID1, PASSWORD1);

  int count = 10;
  while (count != 0 && WiFi.status() != WL_CONNECTED) {
    delay(1000);
    --count;
    Serial.print(".");
  }

  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi 1 connect failed!");

    Serial.print("Connecting to ");
    Serial.print(SSID2);

    WiFi.begin(SSID2, PASSWORD2);

    count = 10;
    while (count != 0 && WiFi.status() != WL_CONNECTED) {
      delay(1000);
      --count;
      Serial.print(".");
    }

    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("WiFi 2 connect failed!");
      WiFi_connect();
    } else {
      Serial.println("WiFi connected");
    }
  } else {
    Serial.println("WiFi connected");
  }
}

void MQTT_connect() {
  if (mqtt.connected()) { return; }

  Serial.print("Connecting to MQTT... ");
  uint8_t ret;
  while (ret = mqtt.connect() != 0) { // connect will return 0 for connected
    Serial.println(mqtt.connectErrorString(ret));

    while (WiFi.status() != WL_CONNECTED) {
      Serial.println("WiFi lost!");
      WiFi_connect();
    }

    Serial.println("Retrying MQTT connection in 5 seconds...");
    mqtt.disconnect();
    delay(5000);
  }

  Serial.println("MQTT Connected!");
}

void publishData() {
  if (publishSensor == 1) {
    float temp = dht.readTemperature();

    if (isnan(temp)) {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }
    
    Serial.print(F("Temperature: "));
    Serial.print(temp);
    Serial.println("°C");

    if (temp == lTemp) {
      Serial.println("=== Not publish! (Equal to last value)");
    } else {
      lTemp = temp;
      
      if (! sensor1.publish(temp, 1, true)) { Serial.println(F("S1 Failed")); } 
      else { Serial.println(F("S1 OK!")); }
    }

    publishSensor = 2;
  } else if (publishSensor == 2) {
    float hum = dht.readHumidity();

    if (isnan(hum)) {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }

    Serial.print(F("Humidity: "));
    Serial.print(hum);
    Serial.println("%");

    if (hum == lHumid) {
      Serial.println("=== Not publish! (Equal to last value)");
    } else {
      lHumid = hum;

      if (! sensor2.publish(hum, 0, true)) { Serial.println(F("S2 Failed")); } 
      else { Serial.println(F("S2 OK!")); }
    }

    publishSensor = 3;
  } else {
    float temp = dht.readTemperature();
    float hum = dht.readHumidity();

    if (isnan(hum) || isnan(temp)) {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }

    float heatIndex = dht.computeHeatIndex(temp, hum, false);

    Serial.print(F("Heat index: "));
    Serial.print(heatIndex);
    Serial.println(F("°C"));

    if (heatIndex == lHeatIdx) {
      Serial.println("=== Not publish! (Equal to last value)");
    } else {
      lHeatIdx = heatIndex;

      if (! sensor3.publish(heatIndex, 2, true)) { Serial.println(F("S3 Failed")); } 
      else { Serial.println(F("S3 OK!")); }
    }

    publishSensor = 1;
  }
}

void button1_callback(char *data, uint16_t len) {
  Serial.print("Hey we're in a button1 callback, the button value is: ");
  Serial.println(data);

  if (strcmp(data, "1") == 0) {
    digitalWrite(BUTTON1_PIN, LOW); 
  }
  if (strcmp(data, "0") == 0) {
    digitalWrite(BUTTON1_PIN, HIGH); 
  }
}

void button2_callback(char *data, uint16_t len) {
  Serial.print("Hey we're in a button2 callback, the button value is: ");
  Serial.println(data);

  if (strcmp(data, "1") == 0) {
    digitalWrite(BUTTON2_PIN, LOW); 
  }
  if (strcmp(data, "0") == 0) {
    digitalWrite(BUTTON2_PIN, HIGH); 
  }
}