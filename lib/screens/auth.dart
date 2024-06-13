import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

import 'package:privatechat/constants.dart';

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

  void _submit() async {
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
            'assets/images/defaultpp.png', 'defaultpp.png');

        if (file.existsSync()) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${userCredentials.user!.uid}.png');
          await storageRef.putFile(file);
          final imageURL = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'username': _enteredEmail.split('@')[0],
            'email': _enteredEmail,
            'image_url': imageURL,
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
              const Icon(Icons.bubble_chart, size: 154),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 48),
                child: Text(
                  'Private Chat',
                  style: kTitleText,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                        decoration: kTextFormFieldDecoration(context)
                            .copyWith(labelText: "Email"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscureText,
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        decoration: kTextFormFieldDecoration(context).copyWith(
                            labelText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureText = !_isObscureText;
                                });
                              },
                            )),
                      ),
                    ),
                    if (!_isLogin)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _isObscureTextConfirm,
                          onSaved: (value) {
                            _enteredConfirmPassword = value!;
                          },
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'The passwords must match.';
                            }
                            return null;
                          },
                          decoration:
                              kTextFormFieldDecoration(context).copyWith(
                                  labelText: "Confirm Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscureTextConfirm
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureTextConfirm =
                                            !_isObscureTextConfirm;
                                      });
                                    },
                                  )),
                        ),
                      ),
                    if (_isAuthenticating) const CircularProgressIndicator(),
                    if (!_isAuthenticating)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _submit();
                            FocusScope.of(context).unfocus();
                          },
                          style: kButtonStyleAuth,
                          child: Text(
                            _isLogin ? 'Login' : 'Signup',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create an account'
                            : 'Already have an account',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
