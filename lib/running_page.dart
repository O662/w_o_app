import 'package:flutter/material.dart';
import 'package:w_o/running_timer_page.dart';
import 'running_plan.dart'; // Import RunningPlanPage
import 'dart:async'; // Import Timer class

class RunningPage extends StatefulWidget {
  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  int _counter = 0;
  int _breakCounter = 0;
  int _repetitions = 1;
  int _currentRepetition = 0;
  bool _isBreak = false;
  Timer? _timer;
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _breakHoursController = TextEditingController();
  final TextEditingController _breakMinutesController = TextEditingController();
  final TextEditingController _breakSecondsController = TextEditingController();
  final TextEditingController _repetitionController = TextEditingController();

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      int hours = int.tryParse(_hoursController.text) ?? 0;
      int minutes = int.tryParse(_minutesController.text) ?? 0;
      int seconds = int.tryParse(_secondsController.text) ?? 0;
      _counter = hours * 3600 + minutes * 60 + seconds;

      int breakHours = int.tryParse(_breakHoursController.text) ?? 0;
      int breakMinutes = int.tryParse(_breakMinutesController.text) ?? 0;
      int breakSeconds = int.tryParse(_breakSecondsController.text) ?? 0;
      _breakCounter = breakHours * 3600 + breakMinutes * 60 + breakSeconds;

      _repetitions = int.tryParse(_repetitionController.text) ?? 1;
      _currentRepetition = 0;
      _isBreak = false;
    });
    _runTimer();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunningTimerPage(
          duration: _counter,
          breakDuration: _breakCounter,
          repetitions: _repetitions,
        ),
      ),
    );
  }

  void _runTimer() {
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
            _counter = int.tryParse(_hoursController.text)! * 3600 +
                int.tryParse(_minutesController.text)! * 60 +
                int.tryParse(_secondsController.text)!;
          } else {
            _timer!.cancel();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    decoration: InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _minutesController,
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _secondsController,
                    decoration: InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _breakHoursController,
                    decoration: InputDecoration(
                      labelText: 'Break Hours',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _breakMinutesController,
                    decoration: InputDecoration(
                      labelText: 'Break Minutes',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _breakSecondsController,
                    decoration: InputDecoration(
                      labelText: 'Break Seconds',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _repetitionController,
              decoration: InputDecoration(
                labelText: 'Repetitions',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startTimer,
              child: Text('Start Timer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RunningPlanPage()),
                );
              },
              child: Text('Go to Running Plan'),
            ),
          ],
        ),
      ),
    );
  }
}