import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'first_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String loginResult = '';

  void attemptLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    String? savedRole = prefs.getString('role');

    if (emailController.text == savedEmail &&
        passwordController.text == savedPassword) {
      final role = _getRoleFromString(savedRole);
      final user = UserModel(email: savedEmail!, role: role);

      setState(() => loginResult = '✅ Login Successful!');

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(user: user),
        ), // ✅ Redirect to HomeScreen
      );
    } else {
      setState(() => loginResult = '❌ Invalid email or password.');
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final user = UserModel(
          email: account.email,
          role: UserRole.student,
        ); // Default as student

        setState(
          () => loginResult = '✅ Google Sign-in Successful: ${account.email}',
        );

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: user),
          ), // ✅ Redirect to HomeScreen
        );
      } else {
        setState(() => loginResult = '❌ Google Sign-in canceled.');
      }
    } catch (e) {
      setState(() => loginResult = '❌ Google Sign-in failed: $e');
    }
  }

  UserRole _getRoleFromString(String? roleStr) {
    switch (roleStr) {
      case 'teacher':
        return UserRole.teacher;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.student;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FirstScreen()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LOG IN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: attemptLogin,
              child: const Text('LOG IN'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Sign in with Google'),
              onPressed: signInWithGoogle,
            ),
            const SizedBox(height: 10),
            Text(loginResult, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
