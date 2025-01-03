import 'package:flutter/material.dart';

class RunningPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Plan'),
      ),
      body: Center(
        child: Text(
          'Running Plan Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}