import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat_app/dataModel/userprofile.dart';
import 'package:realtime_chat_app/database_services.dart';
import 'package:realtime_chat_app/storageservices.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:realtime_chat_app/dataModel/chatModel.dart';
import 'package:realtime_chat_app/dataModel/messageModel.dart';
import 'package:realtime_chat_app/call_fun.dart';

class Chatpage extends StatefulWidget {
  final UserProfile userProfile;
  const Chatpage({super.key, required this.userProfile});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  ChatUser? currentUser, otheruser;
  final user = FirebaseAuth.instance.currentUser!;
  final Database _database = Database();
  final StorageSerivces _storageSerivces = StorageSerivces();
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(id: user.uid, firstName: user.displayName);
    otheruser = ChatUser(
        id: widget.userProfile.uid!, firstName: widget.userProfile.name);
  }

  void callchat(bool bol) async{
    final callid =await
    _database.GenerateUniqueid(uid1: currentUser!.id, uid2: otheruser!.id);
    Get.off(()=>CallPage(callID: callid,bol: bol,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        //centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,  // Keep the row's width minimal
          children: [
            CircleAvatar(
              backgroundImage: widget.userProfile.pfpURL != null
                  ? NetworkImage(widget.userProfile.pfpURL!)
                  : null,
              child: widget.userProfile.pfpURL == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 8), // Space between the profile picture and name
            Text(widget.userProfile.name!),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              callchat(true);
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              callchat(false);
            },
            icon: const Icon(Icons.video_call),
          ),
        ],
      ),
      body: Builderui(),
    );
  }


  Widget Builderui() {
    return StreamBuilder(
        stream: _database.getchatdata(currentUser!.id, otheruser!.id),
        builder: (context, snapshot) {
          List<ChatMessage> messages = [];
          Chat? chat = snapshot.data?.data();
          if (chat != null && chat.messages != null) {
            messages = generatemsglist(chat.messages!);
          }
          return DashChat(
              messageOptions: const MessageOptions(
                  showOtherUsersAvatar: true, showTime: true),
              inputOptions: InputOptions(alwaysShowSend: true, trailing: [
                Medimsg(),
              ]),
              currentUser: currentUser!,
              onSend: onsend,
              messages: messages);
        });
  }

  List<ChatMessage> generatemsglist(List<Message> messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
            medias: [
              ChatMedia(url: m.content!, fileName: '', type: MediaType.image)
            ],
            user: m.senderID == currentUser!.id ? currentUser! : otheruser!,
            createdAt: m.sentAt!.toDate());
      } else {
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otheruser!,
            createdAt: m.sentAt!.toDate(),
            text: m.content!);
      }
    }).toList();
    chatMessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessage;
  }

  Future<void> onsend(ChatMessage message) async {
    if (message.medias?.isNotEmpty ?? false) {
      if (message.medias?.first.type == MediaType.image) {
        Message chatmessage = Message(
          senderID: message.user.id,
          content: message.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(message.createdAt),
        );
        await _database.sendmsg(currentUser!.id, otheruser!.id, chatmessage);
      }
    } else {
      Message chatmessage = Message(
        senderID: message.user.id,
        content: message.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(message.createdAt),
      );
      await _database.sendmsg(currentUser!.id, otheruser!.id, chatmessage);
    }
  }

  // ignore: non_constant_identifier_names
  Widget Medimsg() {
    return IconButton(
        onPressed: Pickimg,
        icon: const Icon(
          Icons.image,
          color: Colors.deepPurple,
          size: 28,
        ));
  }

  // ignore: non_constant_identifier_names
  void Pickimg() async {
    final XFile? image =
    await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String chatid = _database.GenerateUniqueid(
          uid1: currentUser!.id, uid2: otheruser!.id);
      _storageSerivces.uploadchatimg(file: File(image.path), chatid: chatid);
      String? dowloadurl = await _storageSerivces.uploadchatimg(
          file: File(image.path), chatid: chatid);
      if (dowloadurl != null) {
        ChatMessage message = ChatMessage(
            user: currentUser!,
            createdAt: DateTime.now(),
            medias: [
              ChatMedia(url: dowloadurl, fileName: '', type: MediaType.image)
            ]);
        return onsend(message);
      }
    }
  }
}
