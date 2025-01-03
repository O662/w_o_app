import 'package:flutter/material.dart';

class MorningRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Morning Routine'),
      ),
      body: Center(
        child: Text(
          'Morning Routine Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}