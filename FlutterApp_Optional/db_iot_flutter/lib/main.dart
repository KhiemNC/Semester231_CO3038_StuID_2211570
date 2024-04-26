import 'package:db_iot_flutter/pages/pg_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mqtt_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());

  // Hide Status Bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: const AppMainPage(),
    );
  }
}