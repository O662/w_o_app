import 'package:flutter/material.dart';
import 'impulse.dart'; // Import ImpulsePage
import 'study.dart'; // Import StudyPage
import 'routineSelection.dart'; // Import RoutineSelectionPage
import 'workout.dart'; // Import WorkoutPage
import 'info_page.dart'; // Import InfoPage
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const MyHomePage(title: 'MyApp'),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Add the HomePage
    WorkoutPage(), // Add the WorkoutPage next to HomePage
    ImpulsePage(), // Add the ImpulsePage
    StudyPage(), // Add the StudyPage
    InfoPage(), // Add the InfoPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
            label: 'Workout', // Add the Workout item next to Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Impulse', // Add the Impulse item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Study', // Add the Study item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey, // Set the color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoutineSelection()),
          );
        },
        child: Text('Go to Routine Selection'),
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

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    setState(() {
      _greetingMessage = _getGreetingMessage(name);
    });
  }

  String _getGreetingMessage(String name) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    return name.isNotEmpty ? '$greeting, $name.' : '$greeting.';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _greetingMessage,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoutineSelection()),
              );
            },
            child: Text('Go to Routine Selection'),
          ),
        ),
      ],
    );
  }
}
