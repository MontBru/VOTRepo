import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserInfo {
  late final String username;
  late final String email;
  late final String uid;

  MyUserInfo(this.username, this.email, this.uid);

  factory MyUserInfo.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return MyUserInfo(data?['username'], data?['email'], data?['uid']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "email": email,
      "uid": uid
    };
  }

  Future<MyUserInfo> readUser(String uid) async {
    MyUserInfo user = MyUserInfo("", "", "");

    final ref = FirebaseFirestore.instance.collection('users').doc(uid).withConverter(
      fromFirestore: MyUserInfo.fromFirestore,
      toFirestore: (MyUserInfo user_info, _) => user_info.toFirestore(),
    );

    final temp = await ref.get();
    if (temp.exists) {
      user = temp.data()!;
      print(user.username);
    }

    return user;
  }

  Future<String> readUsername(String uid) async {
    MyUserInfo userInfo = await readUser(uid);
    String username = userInfo.username;
    return username;
  }

  Future<void> changeUsername(String uid, String username) async {
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .update({'username': username});
  }

  Future<String> readEmail(String uid) async {
    MyUserInfo userInfo = await readUser(uid);
    String email = userInfo.email;
    return email;
  }
}