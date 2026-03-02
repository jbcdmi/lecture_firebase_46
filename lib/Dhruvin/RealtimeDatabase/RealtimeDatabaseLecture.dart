import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lecture_firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: RealtimeDatabaseLecture()));
}

class RealtimeDatabaseLecture extends StatefulWidget {
  const RealtimeDatabaseLecture({super.key});

  @override
  State<RealtimeDatabaseLecture> createState() => _RealtimeDatabaseLectureState();
}

class _RealtimeDatabaseLectureState extends State<RealtimeDatabaseLecture> {
  String data = "Loading...";

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
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
          var map = dataSnapshot.value as Map;
          data = map["limit"].toString();
        });
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(data, style: TextStyle(fontSize: 40))),
    );
  }
}

/*
*   No-SQL database
*   Data is stored in JSON format
*
* GIT : https://github.com/jbcdmi/lecture_firebase_46.git
* */
