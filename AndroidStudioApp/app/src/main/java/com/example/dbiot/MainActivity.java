package com.example.dbiot;
// import com.example.dbiot.BuildConfig;

import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

// import org.eclipse.paho.android.service.BuildConfig;
import com.github.angads25.toggle.interfaces.OnToggledListener;
import com.github.angads25.toggle.model.ToggleableView;
import com.github.angads25.toggle.widget.LabeledSwitch;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallbackExtended;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.nio.charset.Charset;

import  android.view.Window;
import android.view.WindowManager;

public class MainActivity extends AppCompatActivity {

    MqttManager myMqtt;

    TextView txtTemp, txtHeatIdx, txtHum;
    LabeledSwitch btn1, btn2;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Make activity fullscreen
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
        startMQTT();

        txtTemp = findViewById(R.id.txtTemp);
        txtHum = findViewById(R.id.txtHum);
        txtHeatIdx = findViewById(R.id.txtHeatIdx);

        btn1 = findViewById(R.id.appButton1);
        btn2 = findViewById(R.id.appButton2);

        btn1.setOnToggledListener(new OnToggledListener() {
            @Override
            public void onSwitched(ToggleableView toggleableView, boolean isOn) {
                if (isOn) {
                    publishTopic("khiemnc/feeds/button1", "1");
                } else {
                    publishTopic("khiemnc/feeds/button1", "0");
                }
            }
        });
        btn2.setOnToggledListener(new OnToggledListener() {
            @Override
            public void onSwitched(ToggleableView toggleableView, boolean isOn) {
                if (isOn) {
                    publishTopic("khiemnc/feeds/button2", "1");
                } else {
                    publishTopic("khiemnc/feeds/button2", "0");
                }
            }
        });
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
            public void connectComplete(boolean reconnect, String serverURI) {} // Callback func override

            @Override
            public void connectionLost(Throwable cause) {} // Callback func override

            @Override
            public void messageArrived(String topic, MqttMessage message) throws Exception {
                // Callback func override
                Log.d("TEST", topic + "->" + message.toString());

                // Update UI in main thread
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (topic.contains("sensor1")) {
                            txtTemp.setText(message.toString() + "°C");
                        } else if (topic.contains("sensor2")) {
                            txtHum.setText(message.toString() + "%");
                        } else if (topic.contains("sensor3")) {
                            txtHeatIdx.setText(message.toString() + "°C");
                        } else if (topic.contains("button1")) {
                            if (message.toString().equals("1")) {
                                btn1.setOn(true);
                            } else {
                                btn1.setOn(false);
                            }
                        } else if (topic.contains("button2")) {
                            if (message.toString().equals("1")) {
                                btn2.setOn(true);
                            } else {
                                btn2.setOn(false);
                            }
                        }
                    }
                });
            }

            @Override
            public void deliveryComplete(IMqttDeliveryToken token) {} // Callback func override
        });
    }

    public void publishTopic(String topic, String payload){
        MqttMessage msg = new MqttMessage();
        msg.setId(2211570);
        msg.setQos(0);
        msg.setRetained(false); // If true, publish and receive newest message when subscribe

        byte[] b = payload.getBytes(Charset.forName("UTF-8"));
        msg.setPayload(b);

        try {
            MqttManager.mqttAndroidClient.publish(topic, msg);
        } catch (MqttException e) {}
    }
}