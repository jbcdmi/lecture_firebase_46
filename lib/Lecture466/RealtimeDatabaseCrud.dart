import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lecture_firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: RealtimeDatabaseCrud()));
}

class RealtimeDatabaseCrud extends StatefulWidget {
  const RealtimeDatabaseCrud({super.key});

  @override
  State<RealtimeDatabaseCrud> createState() => _RealtimeDatabaseCrudState();
}

class _RealtimeDatabaseCrudState extends State<RealtimeDatabaseCrud> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  List<Contact> contacts = [];

  @override
  void initState() {
    fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter name..."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter phone..."),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String phone = phoneController.text;
                // saveContact(name, phone);

                Contact contact = Contact(name: name, phone: phone);
                saveContact(contact);
              },
              child: Text("Add Contact"),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(title: Text(contact.name), subtitle: Text(contact.phone)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchContacts() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    ref.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<String, dynamic> data = Map.castFrom(snapshot.value as Map);
      // data.forEach((key, value) {
      //   print("$key  ->  $value");
      // },);

      contacts.clear();
      data.forEach((key, value) {
        Contact contact = Contact.fromJson(Map.castFrom(value));
        contacts.add(contact);
      },);
      setState(() {

      });
    });
  }

  Future<void> saveContact(Contact contact) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users").push();
    await ref.set(contact.toJson());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contact saved successfully")));
  }

  /*Future<void> saveContact(String name, String phone) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users").push();
    var data = {"name": name, "phone": phone};
    // var data = ["C","C++","Java","Dart"];
    await ref.set(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contact saved successfully")));
  }*/
}

class Contact {
  String name;
  String phone;

  Contact({required this.name, required this.phone});

  // map to model class
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(name: json["name"], phone: json["phone"]);
  }

  // model class to map
  Map toJson() {
    return {"name": name, "phone": phone};
  }
}
