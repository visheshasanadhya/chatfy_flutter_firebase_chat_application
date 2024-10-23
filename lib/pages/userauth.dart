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
  bool _isSignup = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleSignupSignin() {
    setState(() {
      _isSignup = !_isSignup;
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

  // Handle Signup
  Future<void> _signup() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Please enter a valid email.');
      return;
    }

    if (!_isValidPassword(password)) {
      _showErrorSnackbar('Password must be at least 6 characters.');
      return;
    }

    try {
      // Create a new user with email and password
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('needsRegistration', true); // Set to true to indicate registration needed

      _showSuccessSnackbar('Signup Successful');
      Get.off(() => const Registrationform()); // Navigate to registration page

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorSnackbar('Email already exists. Please sign in.');
      } else {
        _showErrorSnackbar(e.message ?? 'An error occurred.');
      }
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred.');
    }
  }

  // Handle Signin
  Future<void> _signin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Please enter a valid email.');
      return;
    }

    if (!_isValidPassword(password)) {
      _showErrorSnackbar('Password must be at least 6 characters.');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('needsRegistration', false); // Reset flag on successful sign-in

      // Navigate to HomePage as user is successfully signed in
      Get.off(() => const HomePage());

      _showSuccessSnackbar('Successfully Signed In');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorSnackbar('No user found with this email. Please sign up.');
      } else {
        _showErrorSnackbar(e.message ?? 'An error occurred.');
      }
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred.');
    }
  }

  // Helper method to show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Helper method to show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition:SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.lightBlue,
      body: _buildHeader(),
      bottomNavigationBar: _buildBottomUi(),
    );
  }

  // UI: Build header
  Widget _buildHeader() {
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

  // UI: Build bottom section
  Widget _buildBottomUi() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      height: MediaQuery.of(context).size.height * 0.7,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTextField(_emailController, 'Email', false),
            const SizedBox(height: 20),
            _buildTextField(_passwordController, 'Password', true),
            const SizedBox(height: 30),
            _buildSubmitButton(),
            _buildSwitchAuthButton(),
          ],
        ),
      ),
    );
  }

  // Build reusable text input fields
  Widget _buildTextField(TextEditingController controller, String hintText, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // Build submit button (Signup/Signin)
  Widget _buildSubmitButton() {
    return SizedBox(
      width: 200,
      child: MaterialButton(
        onPressed: () {
          _isSignup ? _signup() : _signin();
        },
        color: Colors.blue,
        child: Text(_isSignup ? 'Signup' : 'Signin'),
      ),
    );
  }

  // Build switch between Signin/Signup button
  Widget _buildSwitchAuthButton() {
    return TextButton(
      onPressed: _toggleSignupSignin,
      child: Text(
        _isSignup ? 'Have an account?  Sign in'
            : "Don't have an account?  Sign up",
        style: const TextStyle(color: Colors.deepPurple),
      ),
    );
  }
}
