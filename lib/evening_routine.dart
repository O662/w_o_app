import 'package:flutter/material.dart';

class EveningRoutine extends StatelessWidget {
  const EveningRoutine({super.key});

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