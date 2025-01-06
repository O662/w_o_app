import 'package:flutter/material.dart';
import 'running_page.dart'; // Import RunningPage
import 'running_plan.dart'; // Import RunningPlanPage

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Schedule'),
              Tab(text: 'Running'),
              Tab(text: 'At Home'),
              Tab(text: 'At Gym'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Content for Schedule', style: TextStyle(fontSize: 24))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RunningPage()),
                      );
                    },
                    child: Text('Go to Running Page'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RunningPlanPage()),
                      );
                    },
                    child: Text('Go to Running Plan Page'),
                  ),
                ],
              ),
            ),
            Center(child: Text('Content for At Home', style: TextStyle(fontSize: 24))),
            Center(child: Text('Content for At Gym', style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}