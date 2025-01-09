import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:w_o/firebase_options.dart';
import 'impulse.dart'; // Import ImpulsePage
import 'study.dart'; // Import StudyPage
import 'routine_selection.dart'; // Import RoutineSelectionPage
import 'workout.dart'; // Import WorkoutPage
import 'profile_page.dart'; // Import the ProfilePage
import 'home_components/routine_recommendation.dart';
import 'home_components/quick_action_row.dart'; // Import QuickActionRow
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:w_o/pages/signup_page.dart'; // Import the SignUpPage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Add the HomePage
    WorkoutPage(), // Add the WorkoutPage next to HomePage
    ImpulsePage(), // Add the ImpulsePage
    StudyPage(), // Add the StudyPage
    WeatherPage(), // Add the WeatherPage
  ];

  static final List<String> _pageTitles = <String>[
    'Home',
    'Workout',
    'Impulse',
    'Study',
    'Weather',
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
                  : AssetImage(
                          'assets/icon/profile_pictures/default_profile_picture.png')
                      as ImageProvider,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
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
  const HomePage({super.key});

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
      _greetingMessage =
          firstName.isNotEmpty ? '$greeting, $firstName.' : '$greeting.';
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: QuickActionRow(), // Use the QuickActionRow widget here
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RoutineSelection()), // Replace with your evening routine page
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (DateTime.now().hour >= 18 ||
                              DateTime.now().hour < 3)
                            AspectRatio(
                              aspectRatio:
                                  2 / 1, // Width to height ratio of 2:1
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/icon/routine_images/night.png'),
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
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Position? _currentPosition;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    if (_currentPosition != null) {
      try {
        final data = await _weatherService.fetchWeatherByCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);
        setState(() {
          _weatherData = data;
        });
      } catch (e) {
        print('Error fetching weather data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather at Your Location'),
      ),
      body: Center(
        child: _weatherData == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Temperature: ${_weatherData!['main']['temp']}°C'),
                  Text('Weather: ${_weatherData!['weather'][0]['description']}'),
                ],
              ),
      ),
    );
  }
}