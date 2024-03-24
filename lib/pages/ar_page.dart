import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

///Phanukorn Khumsalut 640510627

class ARPage extends StatefulWidget {
  const ARPage({
    super.key,
    required this.filter,
  });
  final String? filter;

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  String selectedPrefabs = "";
  final ScreenshotController screenshotController = ScreenshotController();

  bool isNicetrySelected = false;
  bool isNormalSelected = false;
  bool isNewrecordSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isNicetrySelected = widget.filter == "Nicetry";
    isNormalSelected = widget.filter == "Normal";
    isNewrecordSelected = widget.filter == "Newrecord";
    if (isNicetrySelected) {
      setState(() {
        selectedPrefabs = "nicetry";
      });
    } else if (isNormalSelected) {
      setState(() {
        selectedPrefabs = "normal";
      });
    } else if (isNewrecordSelected) {
      setState(() {
        selectedPrefabs = "newrecord";
      });
    }
    print("selectedPrefabs $selectedPrefabs");
    sendToUnity(
      "GameObject",
      "SetFaceFilterPrefabs",
      selectedPrefabs,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.filter);
    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: () {
              // Capture the screenshot
              screenshotController.capture().then((Uint8List? image) async {
                if (image != null) {
                  // Save the screenshot to the gallery
                  final result = await ImageGallerySaver.saveImage(image);
                  if (result['isSuccess']) {
                    // Show a SnackBar indicating successful save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Screenshot saved to gallery')),
                    );
                  } else {
                    // Show a SnackBar indicating error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save screenshot')),
                    );
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: EmbedUnity(
          onMessageFromUnity: (String message) {
            if (message == "scene_loaded") {
              if (isNicetrySelected) {
                setState(() {
                  selectedPrefabs = "nicetry";
                });
              } else if (isNormalSelected) {
                setState(() {
                  selectedPrefabs = "normal";
                });
              } else if (isNewrecordSelected) {
                setState(() {
                  selectedPrefabs = "newrecord";
                });
              }
              print("selectedPrefabs $selectedPrefabs");
              sendToUnity(
                "GameObject",
                "SetFaceFilterPrefabs",
                selectedPrefabs,
              );
            }
          },
        ),
      ),
    );
  }
}
