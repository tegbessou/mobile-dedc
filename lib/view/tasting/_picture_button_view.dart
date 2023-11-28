import 'package:camera/camera.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class PictureButtonView extends StatefulWidget {
  const PictureButtonView({super.key});

  @override
  State<PictureButtonView> createState() {
    return PictureButtonState();
  }
}

class PictureButtonState extends State<PictureButtonView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and then get the location
          // where the image file is saved.
          final image = await _controller.takePicture();
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Icon(
        Icons.camera_alt,
        color: MyColors().blackColor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    initializeCamera();
  }

  void initializeCamera() async
  {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCam = cameras.first;

    _controller = CameraController(
      firstCam,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
