
import 'package:flutter/material.dart';

class AiAdvice extends StatelessWidget {
  const AiAdvice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Advice'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              elevation: 0,
            ),
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What crop are you growing?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const TextField(
                style:
                    TextStyle(color: Colors.white), // Set text color to white
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 244, 184, 94),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'What are your farming practices?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const TextField(
                style:
                    TextStyle(color: Colors.white), // Set text color to white
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 244, 184, 94),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'What issues are you facing?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const TextField(
                style:
                    TextStyle(color: Colors.white), // Set text color to white
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 244, 184, 94),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Advice',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Irrigate when the soil is dry, but not too dry. Over-irrigation can lead to root rot.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0), // Added space for the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Submit Query',
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
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
