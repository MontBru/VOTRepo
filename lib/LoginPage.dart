import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Users.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool flag = true;

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> userSetup(String username, String email) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    if(uid != null) {
      MyUserInfo user = MyUserInfo(username, email, uid,[]);


      //now below I am getting an instance of firebaseiestore then getting the user collection
      //now I am creating the document if not already exist and setting the data.
      final ref = FirebaseFirestore.instance.collection('users').doc(uid).withConverter(
        fromFirestore: MyUserInfo.fromFirestore,
        toFirestore: (MyUserInfo user_info, _) => user_info.toFirestore(),
      );

      ref.set(user);

      print("added user to firebase");
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      userSetup(_controllerUsername.text, _controllerEmail.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryFieldEmail(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: "Email",
      ),
    );
  }

  Widget _entryFieldUsername(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: "Username",
      ),
    );
  }

  Widget _entryFieldPassword(TextEditingController controller) {
    return TextField(
        controller: controller,
        obscureText: flag,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: const Icon(Icons.lock_open_outlined),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  flag = !flag;
                });
              },
              icon: flag? const Icon(Icons.visibility_off): const Icon(Icons.visibility)
          ),
        )
    );
  }

  Widget _errorMessage() {
    return errorMessage != ''
        ? Column(children: [
      const SizedBox(height: 20),
      Text('$errorMessage'),
      const SizedBox(height: 20),
    ])
        : const Text('');
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          side: BorderSide.none,
          shape: const StadiumBorder()),
      onPressed:
      isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register instead' : 'Login instead',
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Center(child: Text('EcoWare')),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isLogin
                ? _entryFieldUsername(_controllerUsername)
                : const SizedBox(),
            _entryFieldEmail(_controllerEmail),
            _entryFieldPassword(_controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
