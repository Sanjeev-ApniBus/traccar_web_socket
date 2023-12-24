import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TraccarWebSocketTesting extends StatefulWidget {
  const TraccarWebSocketTesting({super.key});

  @override
  State<TraccarWebSocketTesting> createState() => _TraccarWebSocketTestingState();
}

class _TraccarWebSocketTestingState extends State<TraccarWebSocketTesting> {
  WebSocketChannel? _channel;

  List<PositionModel> ps = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> establishHttpSession() async {
    try {
      final response = await http.Client().post(
        Uri.parse('https://demo2.traccar.org/api/session'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': 'testcrook8@gmail.com',
          'password': 'mySecuredPassword', // Apply Your Password
        },
      );

      if (response.statusCode == 200) {
        String cookie = response.headers['set-cookie']!.split(';')[0];
        print(cookie);
        establishWebSocketConnection(cookie);
      } else {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error during HTTP session: $error');
    }
  }

  void establishWebSocketConnection(String cookie) {
    final headers = {
      HttpHeaders.cookieHeader: cookie,
    };
    _channel = IOWebSocketChannel.connect("wss://demo2.traccar.org/api/socket", headers: headers);

    _channel!.stream.listen(
      (data) {
        Map<String, dynamic> parsedData = json.decode(data);

        if (parsedData["positions"] != null) {
          print('Received: ${parsedData["positions"]}');

          PositionListModel pos = PositionListModel.fromJson(parsedData["positions"]);
          ps.addAll(pos.positions);
          setState(() {});
        }

        // Update UI or perform other actions with the received data
      },
      onDone: () {
        print('WebSocket closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Traccar WebSocket ',
        ),
        actions: [
          TextButton(
            onPressed: () {
              establishHttpSession();
            },
            child: const Text('Start WebSocket'),
          ),
        ],
      ),
      body:  Center(child: Text("${ps.isNotEmpty  ? ps.last.deviceTime : "No Element There.... "}"),),
    );
  }
}

class PositionListModel {
  List<PositionModel> positions;

  PositionListModel.fromJson(List<dynamic> json) : positions = json.map((position) => PositionModel.fromJson(position)).toList();

  List<Map<String, dynamic>> toJson() => positions.map((position) => position.toJson()).toList();
}

class PositionModel {
  int? id;
  PositionAttributes? attributes;
  int? deviceId;
  String? protocol;
  DateTime? serverTime;
  DateTime? deviceTime;
  DateTime? fixTime;
  bool? outdated;
  bool? valid;
  double? latitude;
  double? longitude;
  double? altitude;
  double? speed;
  double? course;
  String? address;
  double? accuracy;

  PositionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        attributes = json['attributes']==null?null:PositionAttributes.fromJson(json['attributes']),
        deviceId = json['deviceId'],
        protocol = json['protocol'],
        serverTime = DateTime.parse(json['serverTime']).add(Duration(hours: 5, minutes: 30)),
        deviceTime = DateTime.parse(json['deviceTime']).add(Duration(hours: 5, minutes: 30)),
        fixTime = DateTime.parse(json['fixTime']).add(Duration(hours: 5, minutes: 30)),
        outdated = json['outdated'],
        valid = json['valid'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        altitude = json['altitude'],
        speed = json['speed'],
        course = json['course'],
        address = json['address'],
        accuracy = json['accuracy'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'attributes': attributes?.toJson(),
        'deviceId': deviceId,
        'protocol': protocol,
        'serverTime': serverTime?.toIso8601String(),
        'deviceTime': deviceTime?.toIso8601String(),
        'fixTime': fixTime?.toIso8601String(),
        'outdated': outdated,
        'valid': valid,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'speed': speed,
        'course': course,
        'address': address,
        'accuracy': accuracy,
      };
}

class PositionAttributes {
  double? batteryLevel;
  double? distance;
  double? totalDistance;
  bool? motion;

  PositionAttributes.fromJson(Map<String, dynamic> json)
      : batteryLevel = json['batteryLevel'],
        distance = json['distance'],
        totalDistance = json['totalDistance'],
        motion = json['motion'];

  Map<String, dynamic> toJson() => {
        'batteryLevel': batteryLevel,
        'distance': distance,
        'totalDistance': totalDistance,
        'motion': motion,
      };
}
