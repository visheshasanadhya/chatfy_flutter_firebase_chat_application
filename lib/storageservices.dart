import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';

class StorageSerivces {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> UploadImage({
    required File file,
    required String uid,
  }) async {
    try {
      Reference _ref = _storage
          .ref('users/profieimg')
          .child("$uid${p.extension(file.path)}");
      UploadTask uploadTask = _ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      if (taskSnapshot.state == TaskState.success) {
        String dowloadurl = await _ref.getDownloadURL();
        return dowloadurl;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

//   Future<String?> uploadchatimg(
//       {required File file, required String chatid}) async {
//     Reference fileref = _storage
//         .ref("chats/$chatid")
//         .child("${DateTime.now().toIso8601String()}${p.extension(file.path)}");
//     UploadTask uploadTask = fileref.putFile(file);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     if (taskSnapshot.state == TaskState.success) {
//       String dowloadurl = await fileref.getDownloadURL();
//       return dowloadurl;
//     } else {
//       return null;
//     }
//   }
}