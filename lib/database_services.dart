import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:realtime_chat_app/dataModel/userprofile.dart';

class Database {
  Database() {
    setupcollectionref();
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<UserProfile>? _usercollection;


  void setupcollectionref() {
    _usercollection = _firestore.collection('users').withConverter<UserProfile>(
        fromFirestore: (snapsshots, _) =>
            UserProfile.fromJson(snapsshots.data()!),
        toFirestore: (userprofile, _) => userprofile.toJson());
  }

  Future<void> createuserprofile({
    required UserProfile userProfile
  }) async {
    await _usercollection?.doc(userProfile.uid).set(userProfile);
  }
}

