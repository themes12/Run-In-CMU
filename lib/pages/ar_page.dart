import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:runinmor/components/template/white_container.dart';

import '../components/navigation/app_bar.dart';
import '../components/navigation/bottom_navigation_bar_custom.dart';

class ARPage extends StatefulWidget {
  ARPage({super.key});

  final prefabs = ["crown", "ears"];

  int selectedPrefabs = 0;

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.change_circle),
        onPressed: () {
          final selectedPrefabs = widget.prefabs[widget.selectedPrefabs % 2];
          widget.selectedPrefabs += 1;
          sendToUnity(
            "GameObject",
            "SetFaceFilterPrefabs",
            selectedPrefabs, // Message
          );
        },
      ),
      body: EmbedUnity(
        onMessageFromUnity: (String message) {
          if (message == "scene_loaded") {
            final selectedPrefabs = widget.prefabs[widget.selectedPrefabs % 2];
            widget.selectedPrefabs += 1;
            sendToUnity(
              "GameObject",
              "SetFaceFilterPrefabs",
              selectedPrefabs, // Message
            );
          }
        },
      ),
    );
    // return Scaffold(
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.change_circle),
    //     onPressed: () {
    //       final selectedPrefabs = widget.prefabs[widget.selectedPrefabs % 2];
    //       widget.selectedPrefabs += 1;
    //       sendToUnity(
    //         "GameObject",
    //         "SetFaceFilterPrefabs",
    //         selectedPrefabs, // Message
    //       );
    //     },
    //   ),
    //   body: EmbedUnity(
    //     onMessageFromUnity: (String message) {
    //       final selectedPrefabs = widget.prefabs[widget.selectedPrefabs % 2];
    //       widget.selectedPrefabs += 1;
    //       sendToUnity(
    //         "GameObject",
    //         "SetFaceFilterPrefabs",
    //         selectedPrefabs, // Message
    //       );
    //     },
    //   ),
    // );
  }
}
