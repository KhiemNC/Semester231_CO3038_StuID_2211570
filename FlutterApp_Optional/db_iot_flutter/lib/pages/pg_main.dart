import 'package:db_iot_flutter/values/app_assets.dart';
import 'package:db_iot_flutter/values/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:db_iot_flutter/mqtt_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  bool button1 = true;
  bool button2 = true;
  String temp = "null";
  String humid = "null";
  String heatidx = "null";

  late MqttManager myMqtt;

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    myMqtt = MqttManager(
        serverURI: 'io.adafruit.com',
        username: dotenv.get('MQTT_USERNAME'),
        password: dotenv.get('MQTT_PASSWORD'),
        id: '2211570',
        feeds: [
          'khiemnc/feeds/sensor1',
          'khiemnc/feeds/sensor2',
          'khiemnc/feeds/sensor3',
          'khiemnc/feeds/button1',
          'khiemnc/feeds/button2',
        ],
        onConnectedCb: () {
          print('CallbackFunc: Connected to the broker');
        },
        onDisconnectedCb: () {
          print('CallbackFunc: Disconnected from the broker');
        },
        onSubscribedCb: (String topic) {
          print('CallbackFunc: Subscribed to $topic');
        },
        onMessageCb: (String topic, String message) {
          print('CallbackFunc: Received message from $topic: $message');

          if (topic.contains('sensor1')) {
            setState(() {
              temp = '$message°C';
            });
          } else if (topic.contains('sensor2')) {
            setState(() {
              humid = '$message%';
            });
          } else if (topic.contains('sensor3')) {
            setState(() {
              heatidx = '$message°C';
            });
          } else if (topic.contains('button1')) {
            setState(() {
              button1 = message == '1';
            });
          } else if (topic.contains('button2')) {
            setState(() {
              button2 = message == '1';
            });
          }
        }
    );

    myMqtt.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 8,
                child: Container(
                  color: AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(AppAssets.logo),
                        ),
                      ),
                      const Expanded(
                          flex: 80,
                          child: Center(
                              child: Text(
                                  'My Room Environment',
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 20,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          )
                      )
                    ],
                  ),
                )
            ),
            Expanded(
              flex: 100,
              child: Container(
                color: AppColors.backgroundColor,
                child: Column(
                  children: [
                    Expanded(
                        flex: 40,
                        child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 70,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    temp,
                                                    style: const TextStyle(
                                                      fontSize: 44,
                                                      fontFamily: 'Lato',
                                                      color: AppColors.textRed,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 30,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'Temperature',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Lato',
                                                      color: AppColors.textRed,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 70,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    humid,
                                                    style: const TextStyle(
                                                      fontSize: 44,
                                                      fontFamily: 'Lato',
                                                      color: AppColors.textBlue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 30,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'Humidity',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Lato',
                                                      color: AppColors.textBlue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 30,
                                            child: Container(
                                              padding: const EdgeInsets.all(5.0),
                                              alignment: Alignment.centerRight,
                                              child: const Text(
                                                'Heat\nIndex',
                                                style: TextStyle(
                                                  color: AppColors.textOrange,
                                                  fontSize: 20,
                                                  fontFamily: "Lato",
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 70,
                                            child: Container(
                                              padding: const EdgeInsets.all(5.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                heatidx,
                                                style: const TextStyle(
                                                  color: AppColors.textOrange,
                                                  fontSize: 58,
                                                  fontFamily: "Lato",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              )
                            ]
                        )
                    ),
                    Expanded(
                        flex: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(AppAssets.img_room),
                        )
                    ),
                    Expanded(
                        flex: 20,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: const Text(
                                        'Ventilation Fan',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Lato',
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                                      child: Transform.scale(
                                        scale: 2,
                                        child: Switch(
                                          value: button1,
                                          onChanged: (value) {
                                            myMqtt.publish('khiemnc/feeds/button1', value ? "1" : "0", true);
                                            setState(() {
                                              button1 = value;
                                            });
                                          },
                                          activeTrackColor: AppColors.buttonOn,
                                          activeColor: Colors.white,

                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: const Text(
                                        'Curtains Control',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Lato',
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                                      child: Transform.scale(
                                        scale: 2,
                                        child: Switch(
                                          value: button2,
                                          onChanged: (value) {
                                            myMqtt.publish('khiemnc/feeds/button2', value ? "1" : "0", true);
                                            setState(() {
                                              button2 = value;
                                            });
                                          },
                                          activeTrackColor: AppColors.buttonOn,
                                          activeColor: Colors.white,

                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
                flex: 5,
                child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Flutter App by Nguyen Cong Khiem (2211570)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                )
            ),
          ],
        )
    );
  }
}