import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerView extends StatefulWidget {
  final File? file;
  final void Function(File file) setFile;

  const ImagePickerView({super.key, required this.file, required this.setFile});

  @override
  State<StatefulWidget> createState() {
    return ImagePickerViewState();
  }
}

class ImagePickerViewState extends State<ImagePickerView> {
  late ImagePicker imagePicker = ImagePicker();
  late File? file;
  late void Function(File file) setFile;

  @override
  void initState() {
    super.initState();

    setFile = widget.setFile;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => useCamera(ImageSource.camera),
        icon: const Icon(Icons.photo_camera_back_outlined));
  }

  Future<void> useCamera(ImageSource source) async {
    XFile? xFile = await imagePicker.pickImage(source: source);

    if (xFile != null) {
      setFile(File(xFile.path));
    }
  }
}
