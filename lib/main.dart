import 'package:flutter/material.dart';
import 'impulse.dart'; // Import ImpulsePage
import 'study.dart'; // Import StudyPage
import 'routineSelection.dart'; // Import RoutineSelectionPage
import 'workout.dart'; // Import WorkoutPage
import 'info_page.dart'; // Import InfoPage
import 'profile_page.dart'; // Import the ProfilePage
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 183, 143)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  File? _profileImage;
  String _greetingMessage = '';

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Add the HomePage
    WorkoutPage(), // Add the WorkoutPage next to HomePage
    ImpulsePage(), // Add the ImpulsePage
    StudyPage(), // Add the StudyPage
  ];

  static final List<String> _pageTitles = <String>[
    'Home',
    'Workout',
    'Impulse',
    'Study',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? profileImagePath = prefs.getString('profileImage');
    if (profileImagePath != null) {
      setState(() {
        _profileImage = File(profileImagePath);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      return "It's getting late. \nWe recommend starting your evening routine!";
    } else {
      return 'No specific routine recommended at this time.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : AssetImage('assets/icon/profile_pictures/default_profile_picture.png') as ImageProvider,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Impulse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Study',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey, // Set the color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greetingMessage,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Row(
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
                    // Add more buttons here if needed
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoutineSelection()), // Replace with your evening routine page
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (DateTime.now().hour >= 18 || DateTime.now().hour < 3)
                            AspectRatio(
                              aspectRatio: 2 / 1, // Width to height ratio of 2:1
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icon/routine_images/night.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            _routineRecommendation,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.left, // Align text to the left
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}