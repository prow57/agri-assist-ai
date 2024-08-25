import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final List<Message> messages = [
    Message("Bot", "Hello! How can I help you today?", "8:30 PM", isBot: true),
    Message(
        "Luis",
        "I have a question about my plants. Can you help me with that?",
        "8:31 PM"),
    Message("Bot", "Sure, what's the issue?", "8:32 PM", isBot: true),
    Message("Luis", "My plant has yellow leaves.", "8:33 PM"),
    Message(
        "Bot",
        "Yellow leaves could be due to water issues or poor soil quality. What's your watering schedule like?",
        "8:34 PM",
        isBot: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text("Plant health"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageTile(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/logo.png'), // Replace with your profile image path
                  radius: 20,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Write a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Handle send button press
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              message.isBot
                  ? 'assets/logo.png'
                  : 'assets/logo.png', // Replace with appropriate avatar paths
            ),
            radius: 20,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${message.sender} ${message.time}",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4.0),
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: message.isBot ? Colors.green[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(message.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final String time;
  final bool isBot;

  Message(this.sender, this.text, this.time, {this.isBot = false});
}
