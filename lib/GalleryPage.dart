import 'package:flutter/material.dart';
import 'package:photo_upload/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  List<dynamic> images=[];

  void setup() async{
    images=await MyUserInfo.getImages(FirebaseAuth.instance.currentUser!.uid.toString());
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                Container(
                  child: Image.network(images[index]),
                ),
                Container(
                  height:30 ,
                )
              ],
            );
          },
        )
    );
  }
}