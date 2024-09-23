import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID,required this.bol}) : super(key: key);
  final String callID;
  final bool bol;

  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser;
    return ZegoUIKitPrebuiltCall(
      appID:
      1572071081, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
      "7e2cb507e1a15d296ce10bf8f5b779d8b0fcf6a6a72da21a91dc2dd5a2b1a5e6", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: user!.uid,
      userName: "> ${user.displayName}"?? '',
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: bol?ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall():ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}