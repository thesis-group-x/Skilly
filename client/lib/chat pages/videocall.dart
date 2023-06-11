// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

// const String agoraAppId = '6277273b6dd94e7cb4892ffcb6464eb5';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Permission.camera.request();
//   await Permission.microphone.request();
//   runApp(MaterialApp(home: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late RtcEngine _engine;
//   int? _remoteUid;

//   @override
//   void initState() {
//     super.initState();
//     initializeAgora();
//   }

//   Future<void> initializeAgora() async {
//     _engine = await RtcEngine.create(agoraAppId);
//     await _engine.enableVideo();
//     _engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           print("Local user $uid joined");
//         },
//         userJoined: (int uid, int elapsed) {
//           print("Remote user $uid joined");
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print("Remote user $uid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );

//     await _engine.joinChannel(null, 'firstchannel', null, 0);
//   }

//   @override
//   void dispose() {
//     _engine.destroy();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               width: 100,
//               height: 100,
//               child: Center(
//                 child: RtcLocalView.SurfaceView(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return RtcRemoteView.SurfaceView(uid: _remoteUid!);
//     } else {
//       return Text(
//         'Please wait for the remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
