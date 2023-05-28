import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:photo_upload/TakePictureScreen.dart';
import 'ProfilePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraDescription cam;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TakePictureScreen()
    );
  }
}
