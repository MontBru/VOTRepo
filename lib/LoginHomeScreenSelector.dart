import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'MyScreenBuilder.dart';
import 'LoginPage.dart';
import 'Users.dart';

class LoginHomeScreenSelector extends StatefulWidget {
  const LoginHomeScreenSelector({Key? key}) : super (key: key);

  @override
  State<LoginHomeScreenSelector> createState() => _LoginHomeScreenSelectorState();
}

class _LoginHomeScreenSelectorState extends State<LoginHomeScreenSelector>{
  Future<Widget> _buildWidget() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return MyScreenBuilder();
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: _buildWidget(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(value: 0.5, strokeWidth: 2,));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data!;
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}