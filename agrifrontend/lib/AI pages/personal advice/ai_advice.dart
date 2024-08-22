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

  void _clearFields() {
    _cropController.clear();
    _practicesController.clear();
    _issuesController.clear();
    setState(() {
      _advice = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Advice', style: TextStyle(color: Colors.white)),
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
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                _selectedFarmingType == 'Crop Farming'
                    ? 'Name of crop (e.g., maize):'
                    : 'Name of animal (e.g., cattle):',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _cropController,
                decoration: InputDecoration(
                  hintText: _selectedFarmingType == 'Crop Farming'
                      ? 'Enter crop name'
                      : 'Enter animal name',
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'What are your farming practices?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _practicesController,
                decoration: InputDecoration(
                  hintText: 'Describe your practices',
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'What issues are you facing?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _issuesController,
                decoration: InputDecoration(
                  hintText: 'Describe your issues',
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Advice',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                        _advice.isNotEmpty
                            ? _advice
                            : 'Enter details to get advice',
                        style: const TextStyle(fontSize: 16.0),
                      ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getAiResponse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Get Advice'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
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
