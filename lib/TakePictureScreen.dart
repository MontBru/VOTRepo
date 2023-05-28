import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'Users.dart';

class TakePictureScreen extends StatefulWidget {
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String imageUrl='';

  Future<void> setupCam() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }


  @override
  void initState() {
    super.initState();
    setupCam();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child:Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height-240,
          left:MediaQuery.of(context).size.width/2-30,
          child: Container(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  //print(image.path);



                  Reference referenceDirImages=FirebaseStorage.instance.ref().child("images");
                  Reference referenceImgToUpload=referenceDirImages.child(DateTime.now().millisecondsSinceEpoch.toString());

                  await referenceImgToUpload.putFile(File(image.path));

                  imageUrl=await referenceImgToUpload.getDownloadURL();

                  MyUserInfo.addImage(FirebaseAuth.instance.currentUser!.uid.toString(),imageUrl);

                } catch (e) {
                  print(e);
                }
              },
              backgroundColor: Colors.black87,
              child: const Icon(Icons.camera_alt),
            ),
          ),
          ),
      ],
    );
  }
}
