import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registrationpage.dart';
import 'homepage.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  bool _issignup = false;
  TextEditingController emailcont = TextEditingController();
  TextEditingController passcont = TextEditingController();
  final FirebaseAuth _user = FirebaseAuth.instance;

  void _toggle() {
    setState(() {
      _issignup = !_issignup;
    });
  }

  // Email validation
  bool _isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  // Password validation
  bool _isValidPassword(String password) {
    return password.length >= 6; // Minimum length for Firebase
  }

  Future<void> signup() async {
    if (!_isValidEmail(emailcont.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!_isValidPassword(passcont.text.trim())) {
      Get.snackbar('Error', 'Password must be at least 6 characters.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // Check if the email already exists in Firebase Auth
      final List<String> signInMethods = await _user.fetchSignInMethodsForEmail(emailcont.text.trim());
      if (signInMethods.isNotEmpty) {
        Get.snackbar(
          'Error',
          'Email already exists. Please sign in.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create a new user with email and password
      await _user.createUserWithEmailAndPassword(
        email: emailcont.text.trim(),
        password: passcont.text.trim(),
      );

      final pref = await SharedPreferences.getInstance();
      await pref.setBool('needsRegistration', true);

      Get.snackbar(
        'Success',
        'Signup Successful',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Redirect to registration form after signup
      Get.off(() => const Resgistrationform());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred.',  // Use ?? to handle null messages
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signin() async {
    try {
      UserCredential _signin = await _user.signInWithEmailAndPassword(
          email: emailcont.text.trim(), password: passcont.text.trim());

      final pref = await SharedPreferences.getInstance();
      bool needsRegistration = pref.getBool('needsRegistration') ?? true;

      if (needsRegistration) {
        Get.off(() => const Resgistrationform());
      } else {
        Get.off(() => const HomePage());
      }

      Get.snackbar(
        'Success',
        'Successfully Signed In',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.lightBlue,
      body: _buildUi(),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  controller: emailcont,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passcont,
                  decoration: InputDecoration(
                      hintText: 'Password',
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
                        _issignup ? signup() : signin();
                      },
                      color: Colors.blue,
                      child: Text(_issignup ? 'Signup' : 'Signin'),
                    )),
                TextButton(
                  onPressed: _toggle,
                  child: Text(_issignup
                      ? 'Have and account? Signin'
                      : "Dont's have an account? Signup"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUi() {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Container(
        alignment: Alignment.topCenter,
        child: const Text(
          'Get Started!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ),
    );
  }
}