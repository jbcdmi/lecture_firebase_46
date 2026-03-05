import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: RealtimeDatabaseLecture()));
}

class RealtimeDatabaseLecture extends StatefulWidget {
  const RealtimeDatabaseLecture({super.key});

  @override
  State<RealtimeDatabaseLecture> createState() => _RealtimeDatabaseLectureState();
}

class _RealtimeDatabaseLectureState extends State<RealtimeDatabaseLecture> {
  // List<Map<dynamic, dynamic>> users = [];
  List<User> users = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    // single time read
    // ref.get().then((dataSnapshot) {
    //   if (dataSnapshot.exists) {
    //     setState(() {
    //       data = dataSnapshot.value.toString();
    //     });
    //   }
    // });

    // real-time read
    ref.onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        setState(() {
          print("::::: ${dataSnapshot.value}");
          // {-Omn1f2fcpneJwzWeBPy: {email: bhautik, password: 123}}
          var data = dataSnapshot.value as Map<dynamic, dynamic>;

          // users.clear();
          // data.forEach((key, value) {
          //   users.add(value);
          // });

          users.clear();
          data.forEach((id, user) {
            users.add(User.fromJson(Map.castFrom(user), id));
          });
        });
      }
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? editUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "enter email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "enter password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (editUser != null) {
                  // editUser?.email = emailController.text;
                  // editUser?.password = passwordController.text;
                  User user = User(email: emailController.text, password: passwordController.text);
                  editUserData(user, editUser!.id!);
                  editUser = null;
                  emailController.clear();
                  passwordController.clear();
                } else {
                  addUser(emailController.text, passwordController.text);
                }
              },
              child: Text(editUser != null ? "Update" : "Add"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                // Map user = users[index];
                User user = users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // title: Text("${user["email"]}"),
                    // subtitle: Text("${user["password"]}"),
                    title: Text("${user.email}"),
                    subtitle: Text("${user.password}"),
                    tileColor: Colors.indigo.shade100,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            emailController.text = user.email;
                            passwordController.text = user.password;
                            editUser = user;
                            setState(() {});
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteUser(user);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addUser(String email, String password) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users").push();
    await ref.set({"email": email, "password": password});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User added successfully")));
  }

  Future<void> editUserData(User user, String id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    await ref.child(id).update(user.toJson());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User updated successfully")));
  }

  Future<void> deleteUser(User user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    await ref.child(user.id!).remove();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User deleted successfully")));
  }
}

class User {
  String? id;
  final String email;
  final String password;

  User({this.id, required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json, String id) {
    return User(id: id, email: json["email"], password: json["password"]);
  }

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}

/*
*   No-SQL database
*   Data is stored in JSON format
*
* Git : https://github.com/jbcdmi/lecture_firebase_46.git
* */
