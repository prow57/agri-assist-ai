import 'dart:convert';
import 'package:agrifrontend/AI%20pages/AI%20chat/AI_chat_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/authentication/community_signin.dart';
import 'package:agrifrontend/authentication/signin.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommunitySignUp extends StatefulWidget {
  const CommunitySignUp({super.key});

  @override
  _CommunitySignUpState createState() => _CommunitySignUpState();
}

class _CommunitySignUpState extends State<CommunitySignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final fullName = _fullNameController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://agriback-plum.vercel.app/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'])),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Please check your connection.')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    final pages = [
      const HomePage(),
      const PersonalizedAdvicePage(),
      const AllCoursesPage(),
      SettingsPage(),
    ];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the theme
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color subtitleColor = isDarkMode ? Colors.white70 : Colors.grey[600]!;
    Color iconColor = isDarkMode ? Colors.white : Colors.green;
    Color inputFillColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 40),

              Text(
                'Join the Community',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please fill in the details below to sign up',
                style: TextStyle(
                  fontSize: 16,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.person, color: iconColor),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: iconColor),
                        ),
                      ),
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.phone, color: iconColor),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: iconColor),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.lock, color: iconColor),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: iconColor),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.lock_outline, color: iconColor),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: iconColor),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: textColor),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CommunitySignIn()),
                            );
                          },
                          child: const Text(
                            'Login here',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Personalised AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: true, // Ensure labels are always shown
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
