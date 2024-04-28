import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttServerClient? client;

  final String serverURI;
  final String username;
  final String password;
  final String id;
  final List<String> feeds;

  // Callback Function pointer
  Function onConnectedCb;
  Function onDisconnectedCb;
  Function(String) onSubscribedCb;
  Function(String, String) onMessageCb;

  MqttManager({
    required this.serverURI,
    required this.username,
    required this.password,
    required this.id,
    required this.feeds,

    // Callback functions
    this.onConnectedCb = onConnectedDefault,
    this.onDisconnectedCb = onDisconnectedDefault,
    this.onSubscribedCb = onSubscribedDefault,
    this.onMessageCb = messageReceivedDefault,
  });

  Future<void> connect() async {
    client = MqttServerClient(serverURI, username);
    client!.logging(on: false);
    client!.keepAlivePeriod = 20;

    // Setup the callback methods
    client!.onConnected = () => onConnectedCb();
    client!.onDisconnected = () => onDisconnectedCb();
    client!.onSubscribed = (String topic) => onSubscribedCb(topic);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(id)
        .startClean() // Non persistent session for testing
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .withWillQos(MqttQos.atLeastOnce)
        .authenticateAs(username, password);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
    } catch (e) {
      print('Exception: $e');
      client!.disconnect();
    }

    // Check if we are connected
    if (client!.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT client connected');

      // Subscribe to the topics
      subscribeToTopics();

      // Set up a listener for incoming messages
      setupMessageListener();
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client!.connectionStatus?.state}');
      client!.disconnect();
    }
  }

  void subscribeToTopics() {
    for (var feed in feeds) { client!.subscribe(feed, MqttQos.atLeastOnce); }
  }

  void setupMessageListener() {
    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      // Call the callback function
      onMessageCb(c[0].topic, pt);
    });
  }

  static void onConnectedDefault() { print('Default Func: Connected'); }
  static void onDisconnectedDefault() { print('Default Func: Disconnected'); }
  static void onSubscribedDefault(String topic) { print('Default Func: Subscribed topic: $topic'); }
  static void messageReceivedDefault(String topic, String message) {
    print('Default Func: Received message from $topic: $message');}

  void publish(String topic, String message, bool retainval) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: retainval);
  }
}