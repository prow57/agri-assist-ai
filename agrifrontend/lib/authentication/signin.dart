// lib/login_screen.dart
import 'package:flutter/material.dart';


class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Image.asset('assets/images/logo.png', height: 100),
              SizedBox(height: 20),

              // "Your Number"
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // "Password" Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Handle login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 10),

              // Forgot Password and Register Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text('Forgot password?'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle registration
                    },
                    child: Text('Register here'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
