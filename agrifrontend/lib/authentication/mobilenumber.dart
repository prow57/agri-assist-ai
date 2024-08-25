import 'package:flutter/material.dart';

class MobileNumberScreen extends StatelessWidget {
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
                onPressed: () {
                  // Navigate to OTP verification page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtpVerificationScreen()),
                  );
                },
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
