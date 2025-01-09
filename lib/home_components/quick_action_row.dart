import 'package:flutter/material.dart';
import 'package:w_o/routine_selection.dart';
import 'package:w_o/pages/signup_page.dart';
import 'package:w_o/login_page.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoutineSelection()),
              );
            },
            child: Text('Routines'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: Text('Go to Signup Page'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Go to Login Page'),
          ),
          // Add more buttons here if needed
        ],
      ),
    );
  }
}


