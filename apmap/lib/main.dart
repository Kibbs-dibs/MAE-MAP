import 'package:flutter/material.dart';
import 'screens/first_screen.dart';
import 'screens/register_screen.dart';

void main() => runApp(APMapApp());

class APMapApp extends StatelessWidget {
  const APMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APMAP',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
