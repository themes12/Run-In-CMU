import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:runinmor/components/template/white_container.dart';
import 'package:screenshot/screenshot.dart';

import '../components/navigation/app_bar.dart';
import '../components/navigation/bottom_navigation_bar_custom.dart';

class ARPage extends StatefulWidget {
  ARPage({super.key});

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  String cameraDirection ="User";

  bool isNicetrySelected = true;
  bool isNormalSelected = false;
  bool isNewrecordSelected = false;

  @override
  Widget build(BuildContext context) {
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
          SizedBox(height: 16), // Add some space between buttons
          FloatingActionButton(
            child: Icon(Icons.switch_camera),
            onPressed: () {
              if(cameraDirection =="User"){
                cameraDirection = "World";
              }else{
                cameraDirection ="User";
              }
              // Send message to Unity to switch camera
              sendToUnity(
                "GameObject",
                "ChangeScene",
                cameraDirection,
              );
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: EmbedUnity(
          onMessageFromUnity: (String message) {
            if (message == "scene_loaded") {
              String selectedPrefabs = "";
              if (isNicetrySelected) {
                selectedPrefabs = "nicetry";
              } else if (isNormalSelected) {
                selectedPrefabs = "normal";
              } else if (isNewrecordSelected) {
                selectedPrefabs = "newrecord";
              }
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
