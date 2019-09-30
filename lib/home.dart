import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nothotdog/detectorScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';
import 'package:path/path.dart' show join;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    //Select the back camera
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

//Get Image From Gallery
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _gotoDetectorPage(image);
    }
  }

  // take picture from viewfinder
  Future _onTakePicture() async {
    try {
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      controller.takePicture(path).then((file) {
        _gotoDetectorPage(File.fromUri(Uri.parse(path)));
      });
    } catch (e) {
      print(e);
    }
  }

//Function to navigate to the next page
  void _gotoDetectorPage(File file) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetectorScreen(
                  image: file,
                )));
  }

//Widget Declarations
  Widget buildGalleryButton() {
    return Positioned(
      top: 30,
      right: 8,
      child: IconButton(
        iconSize: 35,
        icon: Icon(
          Icons.perm_media,
          color: Colors.white,
        ),
        onPressed: getImage,
      ),
    );
  }

  Widget buildCaptureButton() {
    return Positioned(
      bottom: 16,
      right: 0,
      left: 0,
      child: InkWell(
        onTap: () async {
          await _onTakePicture();
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow,
              border: Border.all(
                width: 3,
                color: Colors.black,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          !controller.value.isInitialized
              ? Container(
                  color: Colors.blue,
                )
              : CameraPreview(controller),
          buildGalleryButton(),
          buildCaptureButton()
        ],
      ),
    );
  }
}
