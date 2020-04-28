import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OpenCamera extends StatefulWidget {
  @override
  _OpenCameraState createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
        CameraDescription(
          name: "1",
          lensDirection: CameraLensDirection.back,
          // sensorOrientation: camera['sensorOrientation'],
        ),
        ResolutionPreset.medium);
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

  @override
  Widget build(BuildContext context) {
    // if (!controller.value.isInitialized) {
    //   return Container();
    // }
    // return AspectRatio(
    //     aspectRatio: controller.value.aspectRatio,
    //     child: CameraPreview(controller));
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Camera"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text("pick Image", style: TextStyle(color: Colors.white)),
              color: Colors.grey[800],
              onPressed: () async {
                await ImagePicker.pickImage(
                    source: ImageSource.camera,
                    preferredCameraDevice: CameraDevice.front);
              },
            ),
          ),
          AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller))
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return AspectRatio(
//         aspectRatio:
//         controller.value.aspectRatio,
//         child: CameraPreview(controller));
//   }
