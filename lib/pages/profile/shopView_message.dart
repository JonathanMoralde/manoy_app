import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  final String name;
  final String receiverId;

  const MessagePage({Key? key, required this.name, required this.receiverId})
      : super(key: key);

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
      final chatRoomId = _generateChatRoomId(userId, widget.receiverId);

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': userId,
        'senderEmail': currentUserEmail,
        'receiverId': widget.receiverId,
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
              _firebaseAuth.currentUser!.uid, widget.receiverId))
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
              final timestamp =
                  (messageData['timestamp'] as Timestamp?)?.toDate();

              if (timestamp != null) {
                return _buildMessageItem(
                    messageData['text'], isCurrentUser, timestamp);
              } else {
                print("Invalid timestamp data");
                return SizedBox.shrink(); // Skip rendering this message
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(
      String text, bool isCurrentUser, DateTime timestamp) {
    final currentUser = _firebaseAuth.currentUser;
    final currentUserFirstName =
        currentUser != null ? currentUser.displayName ?? '' : '';

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (isCurrentUser)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              currentUserFirstName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isCurrentUser
                        ? Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a')
                      .format(timestamp), // Format timestamp in 12-hour format
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
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
