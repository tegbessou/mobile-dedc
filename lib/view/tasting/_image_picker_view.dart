import 'dart:io';

import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/cupertino.dart';
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
        onPressed: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined),
                        Padding(
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                        ),
                        TextDmSans(
                          'Utiliser une photo existante',
                          fontSize: 16,
                          letterSpacing: 0,
                        )
                      ],
                    ),
                    onPressed: () {
                      // close the options modal
                      Navigator.of(context).pop();
                      // get image from gallery
                      useCamera(ImageSource.gallery);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                        ),
                        TextDmSans(
                          'Prendre une nouvelle photo',
                          fontSize: 16,
                          letterSpacing: 0,
                        ),
                      ],
                    ),
                    onPressed: () {
                      // close the options modal
                      Navigator.of(context).pop();
                      // get image from camera
                      useCamera(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
        icon: const Icon(Icons.photo_camera_back_outlined));
  }

  Future<void> useCamera(ImageSource source) async {
    XFile? xFile =
        await imagePicker.pickImage(source: source, imageQuality: 75);

    if (xFile != null) {
      setFile(File(xFile.path));
    }
  }
}
