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

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Timer Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isBreak
                  ? 'Break time left: ${_formatTime(_remainingBreakTime)}'
                  : 'Running time left: ${_formatTime(_remainingTime)}',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Repetitions left: ${widget.repetitions - _currentRepetition}',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}