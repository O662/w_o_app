import 'package:flutter/material.dart';

class ImpulsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impulse Page'),
      ),
      body: Center(
        child: Text(
          'Impulse Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}