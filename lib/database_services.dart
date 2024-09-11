import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:realtime_chat_app/dataModel/userprofile.dart';
import 'package:realtime_chat_app/dataModel/chatModel.dart';


class Database {
  Database() {
    setupcollectionref();
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<UserProfile>? _usercollection;

  CollectionReference? _chatcollection;

  void setupcollectionref() {
    _usercollection = _firestore.collection('users').withConverter<UserProfile>(
        fromFirestore: (snapsshots, _) =>
            UserProfile.fromJson(snapsshots.data()!),
        toFirestore: (userprofile, _) => userprofile.toJson());

    _chatcollection = _firestore.collection('chats').withConverter<Chat>(
        fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
        toFirestore: (snapshot, _) => snapshot.toJson());
  }

  Future<void> createuserprofile({
    required UserProfile userProfile
  }) async {
    await _usercollection?.doc(userProfile.uid).set(userProfile);
  }

  Future<UserProfile?> getprofileimg(String uid) async {
    final doc = await _usercollection?.doc(uid).get();
    return doc?.data();
  }

  Stream<QuerySnapshot<UserProfile>> getuserProfiles() {
    return _usercollection!
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

   // ignore: non_constant_identifier_names
  String GenerateUniqueid({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String Chatid = uids.fold('', (id, uid) => "$id$uid");
    return Chatid;
  }

  Future<bool> checkuserid(String uid1, String uid2) async {
    String chatid = GenerateUniqueid(uid1: uid1, uid2: uid2);
    final result = await _chatcollection?.doc(chatid).get();
    if (result != null) {
      return result.exists;
    } else {
      return false;
    }
  }

  Future<void> createnewchat(String uid1, String uid2) async {
    String chatid = GenerateUniqueid(uid1: uid1, uid2: uid2);
    final docref = _chatcollection!.doc(chatid);
    final chat = Chat(id: chatid, participants: [uid1, uid2], messages: []);
    await docref.set(chat);
  }

  // Stream<DocumentSnapshot<Chat>> getchatdata(String uid1, String uid2) {
  //   String chatid = GenerateUniqueid(uid1: uid1, uid2: uid2);
  //   return _chatcollection?.doc(chatid).snapshots()
  //   as Stream<DocumentSnapshot<Chat>>;
  // }
  //
  // Future<void> sendmsg(String uid1, String uid2, Message message) async {
  //   String chatid = GenerateUniqueid(uid1: uid1, uid2: uid2);
  //   final docref = _chatcollection!.doc(chatid);
  //   await docref.update({
  //     "messages": FieldValue.arrayUnion([message.toJson()])
  //   });
  // }

}

