import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mlkit/mlkit.dart';

class DetectorScreen extends StatefulWidget {
  final File image;

  DetectorScreen({Key key, this.image}) : super(key: key);
  @override
  _DetectorScreenState createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  FirebaseVisionLabelDetector _labelDetector =
      FirebaseVisionLabelDetector.instance;
  List<VisionLabel> _list = <VisionLabel>[];
  bool isHotDog = false, isLoading = true;

  @override
  void initState() {
    super.initState();
    detectImage();
  }

  void detectImage() async {
    try {
      _list = await _labelDetector.detectFromPath(widget.image.path);

      for (var i in _list) {
        if (i.label == 'Hot dog') {
          isHotDog = true;
          break;
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Something horrible happened');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(widget.image), fit: BoxFit.cover)),
          ),
          isLoading
              ? loadingWidget()
              : ResultWidget(
                  isHotDog: isHotDog,
                  list: _list,
                )
        ],
      ),
    );
  }

  Widget loadingWidget() {
    return Container(
      color: Colors.black38,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Text(
            'Evaluating...',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class ResultWidget extends StatelessWidget {
  final bool isHotDog;
  final List<VisionLabel> list;

  ResultWidget({Key key, this.isHotDog, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 200,
          child: Stack(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 50),
                  decoration: BoxDecoration(
                      color: isHotDog ? Colors.green : Colors.red,
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4))),
                  child: Center(
                    child: Text(
                      isHotDog ? 'HotDog!' : 'Not Hotdog!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Center(child: Image.asset('assets/hotdog.png')),
                      Center(
                        child: Icon(
                          isHotDog ? Icons.done : Icons.clear,
                          color: Colors.white,
                          size: 60,
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isHotDog ? Colors.green : Colors.red,
                      border: Border.all(width: 4, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                'Scan Again',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: list.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chip(
                  label: Text(
                    list[index].label,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  elevation: 5.0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
