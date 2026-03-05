import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lecture_firebase/MyApp.dart';
import 'package:lecture_firebase/SignupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                loginUser(nameController.text, passwordController.text);
              },
              child: Text("Login"),
            ),
            Text("OR"),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
              },
              child: Text("Signup"),
            ),
            Text("OR"),
            TextButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: Text("Sign in With Google"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId: '136527670071-nj0i0gt5mlfshj4b0clb5afgn81m1ll5.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser =
      await GoogleSignIn.instance.authenticate(scopeHint: ["email"]);

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-in successful")));
      print(":::::::::::::: Google Sign-in successful");

    } on GoogleSignInException catch (e) {
      print(":::::::::::::: Google Sign-in error: ${e.code}  |  ${e.description}");
      if (e.code == GoogleSignInExceptionCode.canceled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-in canceled or config issue")));
        return;
      }
      rethrow;
    } catch (e) {
      print(":::::::::::::: Error: $e");
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successful")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(),));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}

/*
* CLI - Command Line Interface
* */
