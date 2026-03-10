import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lecture_firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: ViewRealtimeDatabase()));
}

class ViewRealtimeDatabase extends StatefulWidget {
  const ViewRealtimeDatabase({super.key});

  @override
  State<ViewRealtimeDatabase> createState() => _ViewRealtimeDatabaseState();
}

class _ViewRealtimeDatabaseState extends State<ViewRealtimeDatabase> {

  String data = "loading...";
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    // DatabaseReference ref = FirebaseDatabase.instance.ref("quotes"); // way-1
    // DatabaseReference ref = FirebaseDatabase.instance.ref().child("quotes"); // way-2

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("quotes").child("0").child("author");

    // get data once
    // DataSnapshot snapshot = await ref.get();
    // print(snapshot.value);
    // data = snapshot.value.toString();
    // setState(() {
    //
    // });

    // listen to changes
    ref.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      data = snapshot.value.toString();
      setState(() {

      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(data, style: TextStyle(fontSize: 30),));
  }
}

/*
*   Realtime Database
*   -> changes -> manual refresh
*   -> realtime -> auto refresh
* */
