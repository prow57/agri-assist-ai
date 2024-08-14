import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'message_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // Replace this with your actual OpenAI API key
  final String _apiKey =
      'sk-ZxonIMxLFUcVXhY0ZhhU8jUKqPUsxMOlAWNBcRUyBqT3BlbkFJZOom0hmSkhrSXRy6dxzrf7MOru-3X72p6HgeiChq0A';

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _controller.clear();
      _isLoading =
          true; // Show a loading indicator while waiting for the response
    });

    _fetchGPTResponse(text);
  }

  Future<void> _fetchGPTResponse(String userMessage) async {
    const url = 'https://api.openai.com/v1/completions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model':
              'text-davinci-003', // You can change this to 'gpt-4' if available
          'prompt': userMessage,
          'max_tokens': 100,
          'n': 1,
          'stop': null,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final aiResponse = decodedResponse['choices'][0]['text'].trim();

        setState(() {
          _messages.add(Message(text: aiResponse, isUser: false));
          _isLoading =
              false; // Hide the loading indicator once response is received
        });
      } else {
        throw Exception('Failed to load AI response');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide the loading indicator on error
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color:
                          message.isUser ? Colors.green[300] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const CircularProgressIndicator(), // Show loading indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
