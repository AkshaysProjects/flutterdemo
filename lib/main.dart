import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterdemo/providers/auth_provider.dart';
import 'package:flutterdemo/pages/login_page.dart';
import 'package:flutterdemo/pages/home_page.dart';
import 'package:flutterdemo/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<AuthProvider> _authProviderFuture;

  @override
  void initState() {
    super.initState();
    _authProviderFuture = _initializeAuthProvider();
  }

  Future<AuthProvider> _initializeAuthProvider() async {
    var authProvider = AuthProvider(); // Create an instance of AuthProvider
    await authProvider.initialize(); // Wait for initialization
    return authProvider; // Return the initialized AuthProvider
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthProvider>(
      future: _authProviderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ChangeNotifierProvider<AuthProvider>.value(
            value: snapshot.data!,
            child: MaterialApp(
              initialRoute: snapshot.data!.isAuthenticated ? '/home' : '/login',
              routes: {
                '/login': (context) => const LoginPage(),
                '/home': (context) => const HomePage(),
                '/register': (context) => const RegisterPage(),
              },
            ),
          );
        } else {
          // Show loading screen while waiting for initialization
          return const MaterialApp(
              home: Scaffold(body: CircularProgressIndicator()));
        }
      },
    );
  }
}
