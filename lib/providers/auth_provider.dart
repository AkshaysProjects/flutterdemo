import 'package:flutter/material.dart';
import 'package:flutterdemo/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _accessToken;
  String? _refreshToken;
  final Logger _logger = Logger();

  bool get isAuthenticated => _user != null && _accessToken != null;
  UserModel get user => _user!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  Future<void> initialize() async {
    await loadUserFromPrefs();
  }

  Future<void> loadUserFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    final String? accessToken = prefs.getString('accessToken');
    final String? refreshToken = prefs.getString('refreshToken');

    if (userJson != null && accessToken != null && refreshToken != null) {
      final Map<String, dynamic> userMap = json.decode(userJson);
      _user = UserModel.fromJson(userMap);
      _accessToken = accessToken;
      _refreshToken = refreshToken;
      notifyListeners();
    }
  }

  Future<void> login(String input, String password) async {
    Uri uri = Uri.parse('https://posts.akshaykakatkar.tech/auth/login');
    String key = _isEmail(input) ? 'email' : 'username';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {key: input, 'password': password};

    try {
      final response =
          await http.post(uri, headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _refreshToken = data['refresh_token'];
        _user = UserModel(
          name: data['user']['name'],
          username: data['user']['username'],
          email: data['user']['email'],
          phoneNumber: data['user']['phone_number'] ?? '',
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _accessToken!);
        await prefs.setString('refreshToken', _refreshToken!);
        await prefs.setString('user', json.encode(_user!.toJson()));

        notifyListeners();
      } else {
        _logger.w('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Login error: $e');
    }
  }

  Future<void> register(String name, String username, String email,
      String phoneNumber, String password) async {
    Uri uri = Uri.parse('https://posts.akshaykakatkar.tech/auth/register');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'name': name,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'password': password
    };
    try {
      final response =
          await http.post(uri, headers: headers, body: json.encode(body));

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _refreshToken = data['refresh_token'];
        _user = UserModel(
          name: data['user']['name'],
          username: data['user']['username'],
          email: data['user']['email'],
          phoneNumber: data['user']['phone_number'] ?? '',
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _accessToken!);
        await prefs.setString('refreshToken', _refreshToken!);
        await prefs.setString('user', json.encode(_user!.toJson()));

        notifyListeners();
      } else {
        _logger
            .w('Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Registration error: $e');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    _user = null;
    _accessToken = null;
    _refreshToken = null;

    notifyListeners();
  }

  // Helper function to check if input is an email
  bool _isEmail(String input) {
    final emailRegExp = RegExp(r'^\S+@\S+\.\S+$');
    return emailRegExp.hasMatch(input);
  }
}
