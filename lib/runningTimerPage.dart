import 'package:flutter/material.dart';
import 'dart:async';

class RunningTimerPage extends StatefulWidget {
  final int duration;
  final int breakDuration;
  final int repetitions;

  RunningTimerPage({
    required this.duration,
    required this.breakDuration,
    required this.repetitions,
  });

  @override
  _RunningTimerPageState createState() => _RunningTimerPageState();
}

class _RunningTimerPageState extends State<RunningTimerPage> {
  late int _remainingTime;
  late int _remainingBreakTime;
  late int _currentRepetition;
  late bool _isBreak;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _remainingBreakTime = widget.breakDuration;
    _currentRepetition = 0;
    _isBreak = false;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (!_isBreak) {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _isBreak = true;
            _remainingTime = widget.duration;
          }
        } else {
          if (_remainingBreakTime > 0) {
            _remainingBreakTime--;
          } else {
            _isBreak = false;
            _remainingBreakTime = widget.breakDuration;
            _currentRepetition++;
            if (_currentRepetition >= widget.repetitions) {
              _timer.cancel();
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Timer Page'),
      ),
      body: Center(
        child: Text(
          _isBreak
              ? 'Break time left: $_remainingBreakTime seconds'
              : 'Running time left: $_remainingTime seconds',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}