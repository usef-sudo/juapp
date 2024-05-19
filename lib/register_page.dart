import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juinstagram/page1.dart';

import 'device.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _fullnameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
             SizedBox(height: Device.w/16),
            ElevatedButton(
              onPressed: () async {
                // Add your registration logic here
                createAccount(context);
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createAccount(context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (credential.user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid)
            .set({"fullname": _fullnameController.text});

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Page1()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('The password provided is too weak.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("The account already exists for that email."),
          duration: Duration(milliseconds: 1000),
        ));
      }
    }
  }
}
