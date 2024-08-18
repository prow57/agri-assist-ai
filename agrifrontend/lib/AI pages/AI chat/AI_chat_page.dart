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

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _controller.clear();
      _isLoading =
          true; // Show a loading indicator while waiting for the response
    });

    _fetchAPIResponse(text);
  }

  Future<void> _fetchAPIResponse(String userMessage) async {
    const url = 'https://agriback-plum.vercel.app/api/chat/chat';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message':
              userMessage, // Adjust this payload based on your API requirements
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final aiResponse = decodedResponse[
            'response']; // Adjust this key based on your API response

        setState(() {
          _messages.add(Message(text: aiResponse, isUser: false));
          _isLoading =
              false; // Hide the loading indicator once response is received
        });
      } else {
        throw Exception('Failed to load API response');
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
