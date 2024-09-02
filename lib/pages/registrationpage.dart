import 'dart:io';

// import 'package:chatapp_yt/dataModel/userprofile.dart';
// import 'package:chatapp_yt/database_services.dart';
// import 'package:chatapp_yt/pages/homepage.dart';
 import 'package:realtime_chat_app/storageservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resgistrationform extends StatefulWidget {
  const Resgistrationform({super.key});

  @override
  State<Resgistrationform> createState() => _ResgistrationformState();
}

class _ResgistrationformState extends State<Resgistrationform> {
  final ImagePicker _picker = ImagePicker();
  File? selectedimg;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final StorageSerivces _storage = StorageSerivces();
  // final Database _database = Database();

  TextEditingController namecont = TextEditingController();
  TextEditingController emailcont = TextEditingController(
      text: '${FirebaseAuth.instance.currentUser!.email}');
  void pickimg() async {
    final Pickedimg = await _picker.pickImage(source: ImageSource.gallery);
    if (Pickedimg != null) {
      setState(() {
        selectedimg = File(Pickedimg.path);
      });
    }
  }

  // Future<bool> _saveloginstate() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.setBool('isLoggedIn', true);
  // }
  //
  // Future<void> registerAccount() async {
  //   if (selectedimg != null && namecont.text.isNotEmpty) {
  //     try {
  //       final uid = _auth.currentUser!.uid;
  //       final download =
  //       await _storage.UploadImage(file: selectedimg!, uid: uid);
  //       if (download != null) {
  //         await _database.createuserprofile(
  //             userProfile: UserProfile(
  //                 uid: uid,
  //                 name: namecont.text,
  //                 pfpURL: download,
  //                 phonenumber: emailcont.text));
  //       }
  //       await _saveloginstate();
  //      // Get.off(() =>const HomePage());
  //       Get.showSnackbar(const GetSnackBar(
  //         backgroundColor: Colors.blue,
  //         titleText: Text('Successfully registered'),
  //         duration: Duration(seconds: 3),
  //       ));
  //     } catch (e) {
  //       Get.showSnackbar(const GetSnackBar(
  //         backgroundColor: Colors.red,
  //         titleText: Text('Select image and Enter Name'),
  //         duration: Duration(seconds: 3),
  //       ));
  //
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 129, 201, 234),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Registered Yourself!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: pickimg,
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                      selectedimg != null ? FileImage(selectedimg!) : null,
                      child: selectedimg == null
                          ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      )
                          : null,
                    )),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: namecont,
                  decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  enabled: false,
                  controller: emailcont,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: 200,
                    child: MaterialButton(
                      onPressed: () {
                       // registerAccount();
                      },
                      color: Colors.white,
                      child: const Text('Register'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}