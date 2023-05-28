import 'package:flutter/material.dart';
import 'LoginHomeScreenSelector.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginHomeScreenSelector(),
      debugShowCheckedModeBanner: false,
    );
  }
}
