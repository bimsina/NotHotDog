import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nothotdog/detectorScreen.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController controller;

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
    controller.dispose();

    super.dispose();
  }

//Get Image From Gallery
  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _gotoDetectorPage(File.fromUri(Uri.parse(image.path)));
    }
  }

  // take picture from viewfinder
  Future _onTakePicture() async {
    try {
      controller.takePicture().then((file) {
        _gotoDetectorPage(File.fromUri(Uri.parse(file.path)));
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
    return FloatingActionButton.extended(
        onPressed: getImage,
        heroTag: 'pick',
        label: Text('Pick Image'),
        icon: Icon(Icons.image));
  }

  Widget buildCaptureButton() {
    return FloatingActionButton.extended(
        heroTag: 'capture',
        label: Text('Capture image'),
        onPressed: _onTakePicture,
        icon: Icon(Icons.camera));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nothotdog')),
      body: Stack(
        children: <Widget>[
          !controller.value.isInitialized
              ? Container()
              : Center(child: CameraPreview(controller)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildCaptureButton(),
                  Container(
                    width: 50,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text("- or -", style: TextStyle(color: Colors.white)),
                  ),
                  buildGalleryButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
