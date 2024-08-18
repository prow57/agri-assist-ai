import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class FarmingPracticesPage extends StatefulWidget {
  const FarmingPracticesPage({super.key});

  @override
  _FarmingPracticesPageState createState() => _FarmingPracticesPageState();
}

class _FarmingPracticesPageState extends State<FarmingPracticesPage> {
  String _responseContent = '';
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchFarmingPractices();
  }

  Future<void> _fetchFarmingPractices() async {
    const url = 'https://agriback-plum.vercel.app/api/courses/topics';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseContent = response.body;
          _isLoading = false;
          _isError = false;
        });
      } else {
        setState(() {
          _responseContent =
              'Failed to load farming practices: ${response.statusCode}';
          _isLoading = false;
          _isError = true;
        });
      }
    } catch (e) {
      setState(() {
        _responseContent = 'Error: $e';
        _isLoading = false;
        _isError = true;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Practices'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _responseContent));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response copied to clipboard')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: _isError
                    ? Text(
                        _responseContent,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        _responseContent,
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ),
    );
  }
}
