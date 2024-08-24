// @dart=2.17
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WaterGlass extends StatefulWidget {
  const WaterGlass({super.key});

  @override
  _WaterGlassState createState() => _WaterGlassState();
}

class _WaterGlassState extends State<WaterGlass> {
  double _waterAmount = 0.0;
  final double _maxCapacity = 8.0;
  final TextEditingController _controller = TextEditingController();
  String _selectedInterval = "5 minutes";
  final String baseUrl = 'http://192.168.133.236:4000';

 @override
void initState() {
  super.initState();
  tz.initializeTimeZones(); // Ensure timezone data is initialized
  getWaterConsumed();
  _initializeNotifications();
}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleNotification(Duration interval) async {
    final now = tz.TZDateTime.now(tz.local); // Get current local time
    final scheduledTime = now.add(interval); // Calculate the scheduled time

    print('Scheduling notification for: $scheduledTime'); // Log for debugging

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Drink Water',
      'It\'s time to drink water!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'drink_water_channel',
          'Drink Water Notifications',
          channelDescription: 'Reminder to drink water',
          importance: Importance.max,
          priority: Priority.high,
          // Ensure notifications are displayed even if the app is in the background
          // and that notifications are not blocked by battery optimizations
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

void _testNotification() async {
  final now = tz.TZDateTime.now(tz.local); // Get current local time
  final scheduledTime = now.add(const Duration(minutes: 1)); // Schedule 1 minute from now

  print('Current local time: $now'); // Log current time
  print('Testing notification at: $scheduledTime'); // Log scheduled time

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Test Notification',
    'This is a test notification',
    scheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Notifications',
        channelDescription: 'Test notification channel',
        importance: Importance.max,
        priority: Priority.high,
       
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

  void _showReminderSetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reminder Set'),
          content: const Text('Your water reminder has been set successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onSetReminder() {
    Duration interval;

    switch (_selectedInterval) {
      case "5 minutes":
        interval = const Duration(minutes: 5);
        break;
      case "1 hour":
        interval = const Duration(hours: 1);
        break;
      case "2 hours":
        interval = const Duration(hours: 2);
        break;
      case "3 hours":
        interval = const Duration(hours: 3);
        break;
      case "4 hours":
        interval = const Duration(hours: 4);
        break;
      default:
        interval = const Duration(minutes: 5);
    }

    try {
      _scheduleNotification(interval);
      _showReminderSetDialog();
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  void _updateWaterAmount() {
    final newWaterAmount = double.tryParse(_controller.text) ?? 0.0;

    if (newWaterAmount > 0) {
      setState(() {
        _waterAmount += newWaterAmount;
        if (_waterAmount > _maxCapacity) {
          _waterAmount = _maxCapacity;
        } else if (_waterAmount < 0) {
          _waterAmount = 0;
        }
      });
      saveWaterConsumedToday(_waterAmount);
    }
    _controller.clear();
  }

  Future<void> saveWaterConsumedToday(double waterAmount) async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final uri = Uri.parse("$baseUrl/postroutes/saveuserwaterintake");
      final response = await http.post(
        uri,
        body: jsonEncode({'water': waterAmount}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print("Water amount saved successfully");
      } else {
        print("Error in saving data: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getWaterConsumed() async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final uri = Uri.parse("$baseUrl/getroutes/getwaterintake");
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double waterAmount = data['waterIntakeForToday']?.toDouble() ?? 0.0;
        setState(() {
          _waterAmount = waterAmount;
        });
        print("Water amount received successfully: $waterAmount");
      } else {
        print("Error in fetching data: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fillHeight = (_waterAmount / _maxCapacity) * 200; // Adjusted height

    return Commonscaffold(
      title: "Water Intake",
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _testNotification, child: Text("Click to Test Notification")),
            const SizedBox(height: 30),
            const Text(
              "Manage your water intake",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10),
                const Text(
                  "Set Reminder Interval:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 13),
                DropdownButton<String>(
                  value: _selectedInterval,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedInterval = newValue!;
                    });
                  },
                  items: <String>['5 minutes', '1 hour', '2 hours', '3 hours', '4 hours']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _onSetReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Set"),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, // Adjusted width
                  height: 200, // Adjusted height
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.blueAccent, width: 4),
                      right: BorderSide(color: Colors.blueAccent, width: 4),
                      bottom: BorderSide(color: Colors.blueAccent, width: 4),
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: 100, // Adjusted width
                        height: fillHeight,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5), // Added opacity
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(15)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 3),
                CustomPaint(
                  size: const Size(20, 200), // Adjusted height
                  painter: ScalePainter(_maxCapacity),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter water amount (glasses)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateWaterAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add Water Amount"),
            ),
            const SizedBox(height: 20),
            Text(
              "Water left to drink: ${(_maxCapacity - _waterAmount).clamp(0, _maxCapacity)} glasses",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  final double maxCapacity;

  ScalePainter(this.maxCapacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    for (int i = 1; i <= maxCapacity; i++) {
      double y = size.height - (i / maxCapacity) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width / 2, y), paint);
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.grey), text: '$i');
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(size.width / 2 + 5, y - 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(const MaterialApp(home: WaterGlass()));
}
