import 'package:flutter/material.dart';
import 'morningRoutine.dart'; // Import MorningRoutinePage
import 'eveningRoutine.dart'; // Import EveningRoutinePage

class RoutineSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MorningRoutine()),
                );
              },
              child: Text('Morning Routine'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EveningRoutine()),
                );
              },
              child: Text('Evening Routine'),
            ),
          ],
        ),
      ),
    );
  }
}