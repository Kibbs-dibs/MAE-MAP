import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentTime = '';
  String weatherDescription = 'Loading...';
  double? temperature;

  @override
  void initState() {
    super.initState();
    updateTime();
    fetchWeather();

    // Auto-refresh time every 60 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 60));
      if (!mounted) return false;
      updateTime();
      return true;
    });
  }

  void updateTime() {
    final now = DateTime.now();
    final formatted = DateFormat('HH:mm').format(now);
    setState(() => currentTime = formatted);
  }

  Future<void> fetchWeather() async {
    // Replace with your actual API key from OpenWeatherMap
    final apiKey = '2e16f4aa8dbb4a0e91d1126462315051';
    final city = 'Kuala Lumpur';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final desc = data['weather'][0]['main'];
        final temp = data['main']['temp'];
        setState(() {
          weatherDescription = desc;
          temperature = temp;
        });
      } else {
        setState(() => weatherDescription = 'Weather not available');
      }
    } catch (e) {
      setState(() => weatherDescription = 'Error fetching weather');
    }
  }

  String getGreetingForRole(UserRole role) {
    final roleName = role.name[0].toUpperCase() + role.name.substring(1);
    return 'Hello there $roleName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getGreetingForRole(widget.user.role),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/apmaplogo.png', height: 80),
            const SizedBox(height: 20),
            Text(
              currentTime,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (temperature != null)
              Text(
                '$weatherDescription | ${temperature!.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 18),
              )
            else
              Text(weatherDescription),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                backgroundColor: Colors.blueAccent,
              ),
              icon: const Icon(Icons.navigation),
              label: const Text('Navigation'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardScreen(user: widget.user),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
