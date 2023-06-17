import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatMessagesPage extends StatefulWidget {
  final String userName;

  ChatMessagesPage({required this.userName});

  @override
  _ChatMessagesPageState createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    listenToUpdates();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void writeData(String message) {
    String sender =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';
    databaseReference.child('messages').push().set({
      'content': message,
      'sender': sender,
      'recipient': widget.userName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    messageController.clear();
  }

  void listenToUpdates() {
    databaseReference.child('messages').onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> messageData =
            Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        String currentUser = FirebaseAuth.instance.currentUser?.displayName ?? '';
        if ((messageData['sender'] == currentUser && messageData['recipient'] == widget.userName) ||
            (messageData['sender'] == widget.userName && messageData['recipient'] == currentUser)) {
          setState(() {
            messages.insert(0, messageData); 
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(228, 246, 247, 249), 
      appBar: AppBar(
        toolbarHeight: 70.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        backgroundColor: Color(0xFF284855),
        elevation: 12.0,
        title: Row(
          children: [
            SizedBox(width: 20.0),
            Text(widget.userName),
          ],
        ),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.angleLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Container(
              width: 25.0,
              height: 25.0,
              child: IconButton(
                icon: Icon(FontAwesomeIcons.video),
                onPressed: () {
                
                },
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Padding(
            padding: EdgeInsets.only(right: 22.0),
            child: Container(
              width: 25.0,
              height: 25.0,
              child: IconButton(
                icon: Icon(FontAwesomeIcons.phone),
                onPressed: () {
        
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true, 
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                final bool isSentMessage = message['sender'] ==
                    FirebaseAuth.instance.currentUser?.displayName;
                final Alignment alignment = isSentMessage
                    ? Alignment.centerLeft
                    : Alignment.centerRight;
                final Color bubbleColor =
                    isSentMessage ? Color.fromARGB(255, 149, 180, 192) : Color.fromARGB(255, 40, 74, 87);

                return Column(
                  crossAxisAlignment: isSentMessage
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        messages[index]['content'],
                        style: TextStyle(
                          color: isSentMessage ? Color.fromARGB(255, 48, 48, 48) : Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Sent by ${messages[index]['sender']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF284855),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.paperPlane),
                    color: Colors.white,
                    onPressed: () {
                      writeData(messageController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}