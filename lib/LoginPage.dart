

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unix/bottomnavigation_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  bool _isLoading = false;
  bool _isPasswordVisible = false; // Track password visibility

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Load saved credentials when the page initializes
  }

  Future<void> _loadCredentials() async {
    String? username = await storage.read(key: 'username');
    String? password = await storage.read(key: 'password');

    if (username != null) {
      _usernameController.text = username;
    }
    if (password != null) {
      _passwordController.text = password;
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('http://13.210.211.177:8000/app/loginn/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token = responseBody['token'];
        final username = _usernameController.text;

        if (token == null) {
          throw Exception('Token is null');
        }
       
        await storage.write(key: 'auth_token', value: token);
        await storage.write(key: 'username', value: username);
        await storage.write(
            key: 'password',
            value: _passwordController.text); // Save the password securely

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login successful!"),
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid username or password."),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // unix Logo
              Image.asset(
                'assets/images/unix_logo.png', // Ensure the correct path to your logo asset
                height: 120,
              ),
              SizedBox(height: 32),
              // Username Field
              TextFormField(
                controller: _usernameController,
                autofillHints: [
                  AutofillHints.username
                ], // Autofill hint for username
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Control visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle visibility
                      });
                    },
                  ),
                ),
                autofillHints: [
                  AutofillHints.password
                ], // Autofill hint for password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              // Login Button
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
