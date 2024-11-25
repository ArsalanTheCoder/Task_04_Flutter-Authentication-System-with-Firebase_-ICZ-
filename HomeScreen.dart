import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login_Screen.dart';

// Homescreen
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? username;
  String? useremail;

  // Retrieve user data from SharedPreferences
  Future<void> retrieveData() async {
    final preference = await SharedPreferences.getInstance();
    String? fetchedUsername = preference.getString('userName');
    String? fetchedUserEmail = preference.getString('userEmail');

    setState(() {
      username = fetchedUsername;
      useremail = fetchedUserEmail;
    });
  }

  // Logout functionality
  Future<void> logout() async {
    final preference = await SharedPreferences.getInstance();

    await preference.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      backgroundColor: Colors.orange,
      body: Center(
        child: username != null && useremail != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, $username\n$useremail",
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        )
            : const Text("Data is not found"), // Loader while fetching data
      ),
    );
  }
}