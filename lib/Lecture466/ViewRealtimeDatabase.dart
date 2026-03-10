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
  // String data = "loading...";
  // using map
  // List<Map<String, dynamic>> quotes = [];
  // using model class
  List<Quote> quotes = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference ref = FirebaseDatabase.instance.ref("quotes"); // way-1
    // DatabaseReference ref = FirebaseDatabase.instance.ref().child("quotes"); // way-2

    // DatabaseReference ref = FirebaseDatabase.instance.ref().child("quotes").child("0").child("author");

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
      List ll = snapshot.value as List;
      // way-1
      // ll.forEach((element) {
      //   Map<String, dynamic> map = Map.castFrom(element);
      //   quotes.add(map);
      //   print("::::: ${map["author"]}");
      //   // print("::::: $element");
      // });
      // way-2
      // quotes = ll.map((e) => Map<String, dynamic>.from(e)).toList();
      // way-3
      quotes = ll.map((e) => Quote.fromJson(Map<String, dynamic>.from(e)),).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          // using map
          // Map map = quotes[index];
          // return ListTile(title: Text(map["author"]));

          // using model class
          Quote quote = quotes[index];
          return ListTile(title: Text(quote.quote),);
        },
      ),
    );
  }
}

// model class
class Quote {
  String author;
  String quote;
  int id;

  Quote(this.id, this.author, this.quote);

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(json["id"], json["author"], json["quote"]);
  }
}

// map to class object

/*
*   Realtime Database
*   -> changes -> manual refresh
*   -> realtime -> auto refresh
* */
