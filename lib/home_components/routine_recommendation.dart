import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineRecommendation extends StatefulWidget {
  @override
  _RoutineRecommendationState createState() => _RoutineRecommendationState();
}

class _RoutineRecommendationState extends State<RoutineRecommendation> {
  String _greetingMessage = '';
  String _routineRecommendation = '';

  @override
  void initState() {
    super.initState();
    _loadGreetingMessage();
    _routineRecommendation = _getRoutineRecommendation();
  }

  Future<void> _loadGreetingMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName') ?? '';
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    setState(() {
      _greetingMessage = firstName.isNotEmpty ? '$greeting, $firstName.' : '$greeting.';
    });
  }

  String _getRoutineRecommendation() {
    final hour = DateTime.now().hour;
    if (hour >= 3 && hour < 10) {
      return 'We recommend starting your morning routine!';
    } else if (hour >= 18 || hour < 3) {
      return "It's getting late. \nLet's start your evening routine. 🌛";
    } else {
      return 'No specific routine recommended at this time.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greetingMessage,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 8),
        Text(
          _routineRecommendation,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}


