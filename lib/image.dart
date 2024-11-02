import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // Your other code...

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
              // Displaying the app logo
              Center(
                child: Image.asset(
                  'assets/images/unix_logo.png', // Ensure the path is correct
                  height: 120, // Set the height as needed
                ),
              ),
              SizedBox(height: 32),
              // Your username and password fields...
              TextFormField(
                // Username field code...
              ),
              SizedBox(height: 16),
              TextFormField(
                // Password field code...
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Login action...
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
