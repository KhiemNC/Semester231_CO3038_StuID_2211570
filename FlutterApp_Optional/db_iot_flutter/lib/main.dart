import 'package:flutter/material.dart';

import 'mqtt_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  final mqttManager = MqttManager(
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
    }
  );
  await mqttManager.connect();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // how to change the color of the app bar
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            print('Menu button clicked');
          },

        ),
        title: const Text('My App Bar'),
      ),
      body: const Center(
        child: Text(
          'Hello World!',
          style: TextStyle(fontSize: 38),
        ),
      ),
    );
  }
}