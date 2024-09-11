import 'package:flutter/material.dart';
import 'package:realtime_chat_app/dataModel/userprofile.dart';

class Chatpage extends StatefulWidget {

  final UserProfile userProfile;
  const Chatpage({super.key, required this.userProfile});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text(widget.userProfile.name!),
      ),

    );
  }

}
