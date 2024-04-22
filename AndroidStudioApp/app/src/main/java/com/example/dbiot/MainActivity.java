package com.example.dbiot;
// import com.example.dbiot.BuildConfig;

import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

// import org.eclipse.paho.android.service.BuildConfig;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallbackExtended;
import org.eclipse.paho.client.mqttv3.MqttMessage;

public class MainActivity extends AppCompatActivity {

    MqttManager myMqtt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
        startMQTT();
    }

    public void startMQTT(){
        String clientId = "2211570";
        String username = BuildConfig.MQTT_USERNAME;
        String password = BuildConfig.MQTT_PASSWORD;
        String serverUri = "tcp://io.adafruit.com:1883";
        String[] arrayTopics = {"khiemnc/feeds/sensor1",
                                "khiemnc/feeds/sensor2",
                                "khiemnc/feeds/sensor3",
                                "khiemnc/feeds/button1",
                                "khiemnc/feeds/button2"};
        myMqtt = new MqttManager(this, clientId, username, password, serverUri, arrayTopics);
        myMqtt.setCallback(new MqttCallbackExtended() {
            @Override
            public void connectComplete(boolean reconnect, String serverURI) {

            }

            @Override
            public void connectionLost(Throwable cause) {

            }

            @Override
            public void messageArrived(String topic, MqttMessage message) throws Exception {
                Log.d("TEST", topic + "->" + message.toString());
            }

            @Override
            public void deliveryComplete(IMqttDeliveryToken token) {

            }
        });
    }
}