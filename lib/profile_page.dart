import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'info_page.dart'; // Import the InfoPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _firstName = '';
  String _lastName = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
      String? profileImagePath = prefs.getString('profileImage');
      if (profileImagePath != null) {
        _profileImage = File(profileImagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage(
                                  'assets/icon/profile_pictures/default_profile_picture.png')
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _firstName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _lastName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              TabBar(
                tabs: [
                  Tab(text: 'Profile'),
                  Tab(text: 'Settings'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Profile Tab
                    ListView(
                      children: [
                        ExpansionTile(
                          title: Text('Personal Information'),
                          children: [
                            ListTile(
                              title: Text('First Name: $_firstName'),
                            ),
                            ListTile(
                              title: Text('Last Name: $_lastName'),
                            ),
                            // Add more personal information here
                          ],
                        ),
                        // Add more widgets for the profile tab here
                      ],
                    ),
                    // Settings Tab
                    ListView(
                      children: [
                        ExpansionTile(
                          title: Text('Settings'),
                          children: [
                            ListTile(
                              title: Text('App Settings'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InfoPage()),
                                );
                              },
                            ),
                            // Add more settings here
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
