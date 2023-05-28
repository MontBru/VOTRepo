import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyUserInfo {
  late final String username;
  late final String email;
  late final String uid;
  late final List<dynamic> images;


  MyUserInfo(this.username, this.email, this.uid, this.images);

  factory MyUserInfo.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return MyUserInfo(data?['username'], data?['email'], data?['uid'], data?['images']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
      "images": images
    };
  }

  static Future<MyUserInfo> readUser(String uid) async {
    MyUserInfo user = MyUserInfo("", "", "",[]);

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

  static Future<List<dynamic>> getImages(String uid) async{
    MyUserInfo userInfo=await readUser(uid);
    List<dynamic> images=userInfo.images;
    return images;
  }

  static Future<void> addImage(String uid, String image) async {
    MyUserInfo currUser=await MyUserInfo.readUser(uid);
    currUser.images.add(image);
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .update({'images': currUser.images});
  }

  static Future<void> removeImage(String uid, String image) async {
    MyUserInfo currUser=await MyUserInfo.readUser(uid);
    currUser.images.remove(image);
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .update({'images': currUser.images});
    Reference storageRef = FirebaseStorage.instance.refFromURL(image);
    try{
      await storageRef.delete();
    }catch(e){
      print('Error deleting file: $e');
    }
  }
}