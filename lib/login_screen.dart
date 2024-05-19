import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juinstagram/page1.dart';
import 'package:juinstagram/register_page.dart';
import 'package:juinstagram/themeprovider.dart';
import 'package:provider/provider.dart';

import 'device.dart';

class LoginPage extends StatefulWidget {
  static String route = "loginPage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login').tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username'.tr(),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password'.tr(),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: Device.w / 16),
            ElevatedButton(
              onPressed: () {
                // Add your login logic here

                logIn(context);
              },
              child: const Text('Login').tr(),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Create Account').tr(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    themeProvider.toggleThemeData();
                  },
                  icon: Icon(
                    themeProvider.isLightTheme?   Icons.brightness_2_outlined: Icons.brightness_high,
                    size: 70,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logIn(context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (credential.user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Page1()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('wrong email format').tr(),
              actions: <Widget>[
                TextButton(
                  child: const Text('ok').tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (e.code == 'invalid-credential') {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('wrong email or password').tr(),
              actions: <Widget>[
                TextButton(
                  child: const Text('ok').tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
