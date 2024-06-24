import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:privatechat/components/auth_screen_logo.dart';
import 'package:privatechat/model/auth_form.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _isAuthenticating = false;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredConfirmPassword = '';

  var _isObscureText = true;
  var _isObscureTextConfirm = true;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<File> _loadAssetImageToFile(String assetPath, String filename) async {
    final byteData = await rootBundle.load(assetPath);
    final file = await _getLocalFile(filename);
    return file.writeAsBytes(byteData.buffer.asUint8List());
  }

  Future<File> _getLocalFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';
    return File(path);
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final file = await _loadAssetImageToFile(
            'assets/images/defaultpp.jpg', 'defaultpp.jpg');

        if (file.existsSync()) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_photos')
              .child('${userCredentials.user!.uid}.jpg');
          await storageRef.putFile(file);
          final imageURL = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'username': _enteredEmail.split('@')[0].length > 12
                ? _enteredEmail.split('@')[0].substring(0, 12)
                : _enteredEmail.split('@')[0],
            'image_url': imageURL,
            'status': 'Hello I am using PrivateChat',
          });
        } else {
          throw Exception('Default profile picture file not found.');
        }
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(error.message ?? 'Authentication failed. Please try again.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuthIcon(),
              AuthForm(
                formKey: _formKey,
                isLogin: _isLogin,
                isAuthenticating: _isAuthenticating,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                onToggleLoginMode: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                onSubmit: _submit,
                onEmailSaved: (value) {
                  _enteredEmail = value!;
                },
                onPasswordSaved: (value) {
                  _enteredPassword = value!;
                },
                onConfirmPasswordSaved: (value) {
                  _enteredConfirmPassword = value!;
                },
                isObscureText: _isObscureText,
                toggleObscureText: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                isObscureTextConfirm: _isObscureTextConfirm,
                toggleObscureTextConfirm: () {
                  setState(() {
                    _isObscureTextConfirm = !_isObscureTextConfirm;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
