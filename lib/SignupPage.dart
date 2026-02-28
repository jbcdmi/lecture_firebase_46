import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecture_firebase/LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var nameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter password"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signupUser(nameController.text, passwordController.text);
              },
              child: Text("Signup"),
            ),
            Text("OR"),
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("Login")),
          ],
        ),
      ),
    );
  }

  Future<void> signupUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful")));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
