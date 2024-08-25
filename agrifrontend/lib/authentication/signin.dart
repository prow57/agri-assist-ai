import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agrifrontend/lib/authentication/signup.dart';
import 'package:agrifrontend/lib/authentication/mobilenumber.dart';
import 'package:agrifrontend/lib/personalization/languageselection.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://agriback-plum.vercel.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectLanguageScreen()),
                  );
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'])),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error. Please check your connection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                Image.asset('assets/images/logo.png', height: 100),
                SizedBox(height: 20),

                // "Your Number" Field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Your Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // "Password" Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _login,
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
                        Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileNumberScreen()),
                  );
                      },
                      child: Text('Forgot password?'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle registration
                         Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                      },
                      child: Text('Register here'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
