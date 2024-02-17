import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_math/vector_math_64.dart' as vector;

class ARPage extends StatefulWidget {
  const ARPage({Key? key}) : super(key: key);

  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  final GlobalKey _arCoreKey = GlobalKey();
  FaceDetector? faceDetector;
  List<Face> faces = [];
  bool isDetecting = false;
  ArCoreController? arCoreController;
  int cameraIndex = 0; // Variable to track the current camera index

  @override
  void initState() {
    super.initState();
    loadFaceDetector();
  }

  @override
  void dispose() {
    faceDetector?.close();
    arCoreController?.dispose();
    super.dispose();
  }

  Future<void> loadFaceDetector() async {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: true,
        enableClassification: true,
        enableTracking: true,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<ui.Image> loadUIImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));
    return completer.future;
  }

  Future<void> onScreenshotCaptured(ui.Image image) async {
    // Convert ui.Image to ByteData
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    // Process captured image for face detection
    if (!isDetecting) {
      isDetecting = true;
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21, // Adjust image format if needed
          bytesPerRow: image.width * 4, // ARGB format, 4 bytes per pixel
        ),
      );
      final detectedFaces = await faceDetector!.processImage(inputImage);
      setState(() {
        faces = detectedFaces;
      });
      _addFaceNodes(detectedFaces); // Add face filters to the AR scene
      isDetecting = false;
    }
  }

  Future<void> _captureAndProcessScreenshot() async {
    RenderRepaintBoundary boundary =
    _arCoreKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    onScreenshotCaptured(image);
  }

  void _addFaceNodes(List<Face> detectedFaces) async {
    for (var face in detectedFaces) {
      // Load the face filter image
      final faceImage = await loadUIImage('asset/images/glasses.png');

      // Convert ui.Image to ByteData
      final ByteData? byteData = await faceImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List bytes = byteData!.buffer.asUint8List();

      // Create material using the face filter image
      final material = ArCoreMaterial(
        color: const Color.fromARGB(120, 255, 255, 255),
        textureBytes: bytes, // Use the byte data directly
      );

      // Create a sphere node with the face filter material
      final sphere = ArCoreSphere(
        materials: [material],
        radius: 0.1,
      );

      // Create a node and position it based on the face's bounding box
      final node = ArCoreNode(
        shape: sphere,
        position: vector.Vector3(
          face.boundingBox.left + face.boundingBox.width / 2,
          face.boundingBox.top + face.boundingBox.height / 2,
          -1, // Adjust the depth of the filter from the camera
        ),
      );

      // Add the node to the AR scene
      arCoreController?.addArCoreNode(node); // Use addArCoreNode instead of addNode
    }
  }

  // Method to switch camera
  void _switchCamera() {
    arCoreController?.dispose(); // Dispose the current controller
    setState(() {
      cameraIndex = (cameraIndex + 1) % 2; // Toggle between 0 and 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Face Filters'),
      ),
      body: RepaintBoundary(
        key: _arCoreKey,
        child: ArCoreView(
          onArCoreViewCreated: (controller) {
            arCoreController = controller;
          },
          enableTapRecognizer: true,
          type: cameraIndex == 0 ? ArCoreViewType.AUGMENTEDFACE : ArCoreViewType.STANDARDVIEW,
          // Use AUGMENTEDFACE for back camera, STANDARDVIEW for front camera
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _captureAndProcessScreenshot,
            child: const Icon(Icons.camera),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _switchCamera,
            child: const Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }
}
