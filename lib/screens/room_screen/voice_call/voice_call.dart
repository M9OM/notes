
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'dart:math' as math;

// import '../../../utils/constants/utils.dart';

// class AudioCallingScreen extends StatefulWidget {
//   const AudioCallingScreen({super.key});

//   @override
//   State<AudioCallingScreen> createState() => _AudioCallingScreenState();
// }

// final userId = math.Random().nextInt(1000).toString();

// class _AudioCallingScreenState extends State<AudioCallingScreen> {
//   final callIdContr = TextEditingController();
//   final videocallcontr = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Call'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                   hintText: 'Call Id', border: OutlineInputBorder()),
//               controller: callIdContr,
//             ),
//             TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AudioCallPage(
//                             callingId: callIdContr.text.toString()),
//                       ));
//                 },
//                 child: Text('Call')),
//                 //For video Calling
//             TextFormField(
//               decoration: InputDecoration(
//                   hintText: ' Video Call Id', border: OutlineInputBorder()),
//               controller: videocallcontr,
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

// class AudioCallPage extends StatelessWidget {
//   final String callingId;
//   const AudioCallPage({super.key, required this.callingId});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ZegoUIKitPrebuiltCall(
//         appID: Utils.appId,
//         appSign: Utils.appSign,
//         callID: callingId,
//         config: ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//           ..onOnlySelfInRoom = ((context) => Navigator.pop(context)),
//         userID: userId,
//         userName: 'sahil_' + userId.toString(),
//       ),
//     );
//   }
// }
// //For video Calling
