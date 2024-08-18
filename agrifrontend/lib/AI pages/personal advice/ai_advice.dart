import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiAdvice extends StatefulWidget {
  const AiAdvice({super.key});

  @override
  _AiAdviceState createState() => _AiAdviceState();
}

class _AiAdviceState extends State<AiAdvice> {
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _practicesController = TextEditingController();
  final TextEditingController _issuesController = TextEditingController();
  String _advice = '';
  bool _isLoading = false;
  String _selectedFarmingType = 'Crop Farming'; // Default selected option

  Future<void> _getAiResponse() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('https://agriback-plum.vercel.app/api/advice/get-advice');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'type': _selectedFarmingType,
        'product': _cropController.text,
        'practices': _practicesController.text,
        'issues': _issuesController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _advice = data['advice'];
      });
    } else {
      setState(() {
        _advice = 'Failed to get advice. Please try again later.';
      });
      print('Error: ${response.statusCode} - ${response.body}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Advice',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your farming type:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              DropdownButton<String>(
                value: _selectedFarmingType,
                items: <String>['Crop Farming', 'Animal Rearing']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFarmingType = newValue!;
                    _cropController.clear();
                    _practicesController.clear();
                    _issuesController.clear();
                    _advice = '';
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                _selectedFarmingType == 'Crop Farming'
                    ? 'Name of crop (e.g., maize):'
                    : 'Name of animal (e.g., cattle):',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _cropController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 189, 226, 208),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'What are your farming practices?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _practicesController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 189, 226, 208),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'What issues are you facing?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _issuesController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 189, 226, 208),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Advice',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(_advice.isNotEmpty
                        ? _advice
                        : 'Enter details to get advice'),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _getAiResponse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Get Advice'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Back'),
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
