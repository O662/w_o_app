import 'package:flutter/material.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Page'),
      ),
      body: Center(
        child: Text(
          'Study Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}