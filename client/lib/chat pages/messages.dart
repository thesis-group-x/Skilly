import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatMessagesPage(userName: 'User Name'), 
    );
  }
}

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
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _sdpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenToUpdates();
    initWebRTC();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _localStream?.dispose();
    _peerConnection?.close();
    _sdpController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void initWebRTC() async {
    await _createPeerConnection();
    await _getUserMedia();

    if (_peerConnection != null && _localStream != null) {
      _createOffer();
    }
  }

  Future<void> _createPeerConnection() async {
    try {
      Map<String, dynamic> configuration = {
        'iceServers': [
          {'url': 'stun:stun.l.google.com:19302'},
        ],
      };
      _peerConnection = await createPeerConnection(configuration, {});

      _peerConnection?.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate != null) {
          // Send the candidate to the other peer using your signaling mechanism
        }
      };

      _peerConnection?.onTrack = (RTCTrackEvent event) {
        if (event.track.kind == 'video' && event.streams.isNotEmpty) {
          setState(() {
            _remoteStream = event.streams[0];
          });
        }
      };
    } catch (e) {
      print('Failed to create PeerConnection: ${e.toString()}');
    }
  }

  Future<void> _getUserMedia() async {
    try {
      final Map<String, dynamic> mediaConstraints = {
        'audio': true,
        'video': true,
      };

      MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      setState(() {
        _localStream = stream;
      });

      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });
    } catch (e) {
      print('Failed to get user media: ${e.toString()}');
    }
  }

  Future<void> _createOffer() async {
    try {
      RTCSessionDescription description = await _peerConnection!.createOffer({});
      _peerConnection!.setLocalDescription(description);

    
    } catch (e) {
      print('Failed to create offer: ${e.toString()}');
    }
  }

  Future<void> _createAnswer() async {
    try {
      RTCSessionDescription description = await _peerConnection!.createAnswer({});
      _peerConnection!.setLocalDescription(description);

    
    } catch (e) {
      print('Failed to create answer: ${e.toString()}');
    }
  }

  Future<void> _setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection!.setRemoteDescription(description);
  }

  Future<void> _addCandidate(RTCIceCandidate candidate) async {
    await _peerConnection!.addCandidate(candidate);
  }

  void startVideoCall() async {
    if (_peerConnection != null && _localStream != null) {
     
    } else {
      print('PeerConnection or LocalStream is null');
    }
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
                  startVideoCall();
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
                onPressed: () {},
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
                final Color bubbleColor = isSentMessage
                    ? Color.fromARGB(255, 149, 180, 192)
                    : Color.fromARGB(255, 40, 74, 87);
                final Color textColor = isSentMessage ? Colors.black : Colors.white;

                return Align(
                  alignment: alignment,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      message['content'],
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
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
             
 child: IconButton(
                    icon: Icon(Icons.send),
                    color: Color.fromARGB(255, 58, 55, 55),
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

