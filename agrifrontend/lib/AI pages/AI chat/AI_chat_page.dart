import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart'; // For TTS
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
  late FlutterTts _flutterTts; // TTS instance
  final _quickSuggestions = ['What crops should I plant?', 'Tell me about soil health', 'How to prevent pests?'];

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
    _flutterTts = FlutterTts(); // Initialize TTS
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMessages = _messages.map((message) => jsonEncode({
          'text': message.text,
          'isUser': message.isUser,
        })).toList();
    await prefs.setStringList('chatMessages', savedMessages);
  }

  Future<void> _loadSavedMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedMessages = prefs.getStringList('chatMessages');

    if (savedMessages != null) {
      setState(() {
        _messages.addAll(savedMessages.map((msg) {
          Map<String, dynamic> messageData = jsonDecode(msg);
          return Message(
            text: messageData['text'],
            isUser: messageData['isUser'],
          );
        }).toList());
      });
    }
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });

    _saveMessages();
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
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final aiResponse = decodedResponse['response'];

        setState(() {
          _messages.add(Message(text: aiResponse, isUser: false));
          _isLoading = false;
        });

        _saveMessages();

        // Auto-play the AI response using TTS
        _speak(aiResponse);
      } else {
        throw Exception('Failed to load API response');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text); // Use TTS to speak the message
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'AI Chat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Image.asset(
              'assets/logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: message.isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.isUser ? 'You' : 'AI',
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? Colors.green[400]
                                : Colors.blueGrey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16.0),
                              topRight: const Radius.circular(16.0),
                              bottomLeft: message.isUser
                                  ? const Radius.circular(16.0)
                                  : const Radius.circular(0),
                              bottomRight: message.isUser
                                  ? const Radius.circular(0)
                                  : const Radius.circular(16.0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: message.isUser
                                    ? Text(
                                        message.text,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.5,
                                        ),
                                      )
                                    : MarkdownBody(
                                        data: message.text,
                                        styleSheet: MarkdownStyleSheet(
                                          p: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                              ),
                              if (!message.isUser)
                                IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: () => _speak(message.text), // Play TTS manually
                                ),
                            ],
                          ),
                        ),
                        Text(
                          _formatTimestamp(DateTime.now()), // Display current timestamp
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'AI is typing...',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            // Quick suggestions
            Wrap(
              spacing: 8.0,
              children: _quickSuggestions.map<Widget>((suggestion) {
                return ActionChip(
                  label: Text(suggestion),
                  onPressed: () => _sendMessage(suggestion),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null, // Adaptive height for input field
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            // Handle voice input
                          },
                        ),
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
