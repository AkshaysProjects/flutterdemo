import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterdemo/providers/auth_provider.dart';

// Registration page UI and logic
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form and field controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Register user with provided details
  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(
        _nameController.text,
        _usernameController.text,
        _emailController.text,
        _phoneNumberController.text,
        _passwordController.text,
      );

      if (authProvider.isAuthenticated) {
        _navigateToHome();
      }
    }
  }

  // Navigate to the home screen
  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  // Navigate to the login screen
  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // Render registration form and fields
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const CircleAvatar(
                    radius: 50, child: Icon(Icons.person_add, size: 50)),
                const SizedBox(height: 20),
                const Text('Register',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // Name input field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 20),
                // Username input field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a username'
                      : null,
                ),
                const SizedBox(height: 20),
                // Email input field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an email address'
                      : !value.contains('@')
                          ? 'Please enter a valid email address'
                          : null,
                ),
                const SizedBox(height: 20),
                // Phone number input field
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a phone number'
                      : null,
                ),
                const SizedBox(height: 20),
                // Password input field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a password'
                      : value.length < 6
                          ? 'Password must be at least 6 characters long'
                          : null,
                ),
                const SizedBox(height: 20),
                // Confirm password input field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please confirm your password'
                      : _passwordController.text != value
                          ? 'Passwords do not match'
                          : null,
                ),
                const SizedBox(height: 40),
                // Register button
                ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 20),
                // Link to login page
                TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text('Already have an account? Login here',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
