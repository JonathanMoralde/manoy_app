import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class MessagePage extends StatefulWidget {
  final String name;
  final String shopId;

  const MessagePage({
    Key? key,
    required this.name,
    required this.shopId,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    final String userId = _firebaseAuth.currentUser?.uid ?? '';
    final String text = _messageController.text.trim();
    final currentUserEmail = _firebaseAuth.currentUser!.email.toString();

    if (text.isNotEmpty) {
      final chatRoomId = _generateChatRoomId(userId, widget.shopId);

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': userId,
        'senderEmail': currentUserEmail,
        'receiverId': widget.shopId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  String _generateChatRoomId(String userId1, String userId2) {
    final List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat_rooms')
          .doc(_generateChatRoomId(
              _firebaseAuth.currentUser!.uid, widget.shopId))
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }

        final messages = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        return Padding(
          padding:
              const EdgeInsets.only(bottom: 14.0), // Add space at the bottom
          child: ListView.builder(
            reverse: true, // Start from the bottom
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messageData = messages[messages.length - index - 1];
              final bool isCurrentUser =
                  messageData['senderId'] == _firebaseAuth.currentUser!.uid;
              return _buildMessageItem(messageData['text'], isCurrentUser);
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(String text, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isCurrentUser ? Colors.white : Colors.black,
            fontSize: 18, // Adjust the font size as needed
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            child: StyledTextField(
              controller: _messageController,
              hintText: 'Type a message...',
              obscureText: false,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('${widget.name} '),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }
}
