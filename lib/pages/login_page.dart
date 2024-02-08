import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key); // Constructor

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controllers for form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Handles login logic
  void _handleLogin() {}

  // Navigates to the register page
  void _navigateToRegister() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            const CircleAvatar(
                radius: 50, child: Icon(Icons.post_add, size: 50)),
            const SizedBox(height: 20),

            // Title
            const Text('Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            // Username/email input field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username or Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),

            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 40),

            // Login button
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),

            // Register button
            OutlinedButton(
              onPressed: _navigateToRegister,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: Colors.blue),
              ),
              child:
                  const Text('Register', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
