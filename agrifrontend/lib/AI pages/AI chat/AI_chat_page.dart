import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart'; // For TTS
import 'package:speech_to_text/speech_to_text.dart' as stt; // For voice input
import 'message_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  late FlutterTts _flutterTts; // TTS instance
  late stt.SpeechToText _speechToText; // Speech-to-text instance
  bool _isListening = false; // Track if currently listening for speech
  bool _ttsEnabled = true; // Toggle for TTS
  bool _isSpeaking = false; // Track if the TTS is currently speaking
  bool _isPaused = false; // Track if TTS is paused
  String _voiceInput = ''; // Store voice input text
  final _quickSuggestions = ['What crops should I plant?', 'Tell me about soil health', 'How to prevent pests?'];

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
    _loadTtsPreference();
    _flutterTts = FlutterTts(); // Initialize TTS
    _speechToText = stt.SpeechToText(); // Initialize Speech-to-Text
    WidgetsBinding.instance.addObserver(this); // To detect app lifecycle changes

    // Set TTS completion listener to handle when speaking ends
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer when the widget is disposed
    _speechToText.stop(); // Stop speech recognition if it's running
    _flutterTts.stop(); // Stop TTS if it's running
    _controller.dispose();
    super.dispose();
  }

  // Detect when the app's lifecycle state changes (e.g., when user navigates away)
   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      if (_isListening) {
        _toggleRecording(); // Stop recording when navigating away
      }
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMessages = _messages
        .map((message) => jsonEncode({
              'text': message.text,
              'isUser': message.isUser,
            }))
        .toList();
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

  Future<void> _saveTtsPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ttsEnabled', _ttsEnabled);
  }

  Future<void> _loadTtsPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ttsEnabled = prefs.getBool('ttsEnabled') ?? true; // Default to TTS enabled
    });
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

        // Auto-play the AI response using TTS if enabled
        if (_ttsEnabled) {
          _speak(aiResponse);
        }
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
    if (_ttsEnabled) {
      setState(() {
        _isSpeaking = true;
        _isPaused = false;
      });
      await _flutterTts.speak(text); // Use TTS to speak the message
    }
  }

  Future<void> _pauseTTS() async {
    await _flutterTts.pause(); // Pause the TTS
    setState(() {
      _isPaused = true;
      _isSpeaking = false;
    });
  }

  Future<void> _resumeTTS() async {
    setState(() {
      _isSpeaking = true;
      _isPaused = false;
    });
    await _flutterTts.speak(_voiceInput); // Resume speaking
  }


Future<void> _requestMicPermission() async {
  var status = await Permission.microphone.status;
  if (!status.isGranted) {
    status = await Permission.microphone.request();
    if (!status.isGranted) {
      print("Microphone permission not granted");
    }
  }
}


  Future<void> _stopTTS() async {
    await _flutterTts.stop(); // Stop the TTS
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Toggle TTS and save preference
  void _toggleTTS(bool enabled) {
    setState(() {
      _ttsEnabled = enabled;
      _saveTtsPreference();
    });
  }

  // Handle voice input using Speech-to-Text
  void _toggleRecording() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();

      // If recognized words are available, send them as a message
      if (_voiceInput.isNotEmpty) {
        _sendMessage(_voiceInput);
      }
    } else {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _voiceInput = result.recognizedWords;
            });
          },
        );
      } else {
        print("Speech recognition not available");
      }
    }
  }


  // Message bubble widget with TTS controls under the message
  Widget _buildMessageBubble(Message message) {
    return Column(
      crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message.isUser ? 'You' : 'AI',
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.green[400] : Colors.blueGrey[200],
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
            ],
          ),
        ),
        // TTS control buttons (under message)
        if (!message.isUser)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                onPressed: _isPaused ? _resumeTTS : _pauseTTS, // Play/Pause TTS
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: _stopTTS, // Stop TTS
              ),
            ],
          ),
        Text(
          _formatTimestamp(DateTime.now()), // Display timestamp
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
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
        title: const Text(
          'AI Chat',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.green[700], // Improved color for the AppBar
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              const Text('Turn off Speech', style: TextStyle(fontSize: 14)), // Label for the mute toggle
              Switch(
                value: _ttsEnabled,
                onChanged: _toggleTTS,
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
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
                  return _buildMessageBubble(message);
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
              child: Column(
                children: [
                  // Show "Recording..." message when listening
                  if (_isListening)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Recording...',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening ? Colors.red : Colors.black,
                        ),
                        onPressed: _toggleRecording, // Start/Stop recording
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: null, // Adaptive height for input field
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Type a message or use the mic...',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
