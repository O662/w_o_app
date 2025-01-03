import 'package:flutter/material.dart';
import 'runningPage.dart';
import 'runningTimerPage.dart';
import 'impulse.dart'; // Import ImpulsePage
import 'study.dart'; // Import StudyPage
import 'routineSelection.dart'; // Import RoutineSelectionPage

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 58, 183, 143)),
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
  int _counter = 0;
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Add the HomePage
    RunningPage(), // Add the RunningPage
    ImpulsePage(), // Add the ImpulsePage
    StudyPage(), // Add the StudyPage
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            icon: Icon(Icons.directions_run),
            label: 'Running', // Add the Running item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Impulse', // Add the Impulse item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Study', // Add the Study item
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

class HomePage extends StatelessWidget {
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