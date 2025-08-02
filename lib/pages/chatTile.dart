import 'package:realtime_chat_app/dataModel/userprofile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function ontap;
  const ChatTile({super.key, required this.userProfile, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.black26,
        onTap: () {
          ontap();
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userProfile.pfpURL!),
        ),
        title: Text(userProfile.name!),
      ),
    );
  }
}