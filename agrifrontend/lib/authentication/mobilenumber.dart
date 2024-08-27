import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agrifrontend/authentication/otpverification.dart';
import 'package:http/http.dart' as http;

class MobileNumberScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _sendOtp(BuildContext context) async {
    final phone = _phoneController.text;

    if (phone.isEmpty) {
      // Show a snackbar or dialog to ask the user to enter a phone number
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your mobile number.')),
      );
      return;
    }

    try {
      final checkResponse = await http.post(
        Uri.parse('https://agriback-plum.vercel.app/api/auth/check-phone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (checkResponse.statusCode == 200) {
        final otpResponse = await http.post(
          Uri.parse('https://agriback-plum.vercel.app/api/verify/send-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phone': phone}),
        );

        if (otpResponse.statusCode == 200) {
          // OTP sent successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent successfully.')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpVerification(phone: '',)),
          );
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP. Please try again.')),
          );
        }
      } else if (checkResponse.statusCode == 404) {
        // Handle error from the check-phone API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No account associated with that number.')),
        );
      } else {
        // Handle other errors from the check-phone API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to verify phone number. Please try again.')),
        );
      }
    } catch (error) {
      // Handle network error
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Enter Mobile Number" Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Send OTP Button
              ElevatedButton(
                onPressed: () => _sendOtp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
