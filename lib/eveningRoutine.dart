import 'package:flutter/material.dart';

class EveningRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evening Routine'),
      ),
      body: Center(
        child: Text(
          'Evening Routine Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}