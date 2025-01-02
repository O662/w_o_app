import 'package:flutter/material.dart';

class RunningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Page'),
      ),
      body: Center(
        child: Text(
          'This is the Running Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}