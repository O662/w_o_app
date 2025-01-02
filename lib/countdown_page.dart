import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart'; // Import the main.dart file to access the notification plugin

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int _counter = 10;
  int _breakCounter = 5;
  int _repetitions = 1;
  int _currentRepetition = 0;
  bool _isBreak = false;
  Timer? _timer;
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _breakController = TextEditingController();
  final TextEditingController _repetitionController = TextEditingController();

  void _startCountdown() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _counter = int.tryParse(_durationController.text) ?? 10;
      _breakCounter = int.tryParse(_breakController.text) ?? 5;
      _repetitions = int.tryParse(_repetitionController.text) ?? 1;
      _currentRepetition = 0;
      _isBreak = false;
    });
    _runCountdown();
  }

  void _runCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0 && !_isBreak) {
          _counter--;
        } else if (_counter == 0 && !_isBreak) {
          _isBreak = true;
          _counter = _breakCounter;
        } else if (_counter > 0 && _isBreak) {
          _counter--;
        } else if (_counter == 0 && _isBreak) {
          _isBreak = false;
          _currentRepetition++;
          if (_currentRepetition < _repetitions) {
            _counter = int.tryParse(_durationController.text) ?? 10;
          } else {
            _timer!.cancel();
            _showNotification();
          }
        }
      });
    });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'countdown_channel', // Channel ID
      'Countdown Notifications', // Channel Name
      channelDescription: 'Notifications for countdown completion', // Channel Description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Countdown Complete',
      'The countdown has finished.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationController.dispose();
    _breakController.dispose();
    _repetitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Countdown: $_counter seconds',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter countdown duration (seconds)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _breakController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter break duration (seconds)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _repetitionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter number of repetitions',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _startCountdown,
              child: Text('Start Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}