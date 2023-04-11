import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera {
  Future<File?> getImage(imageSource) async {
    var status = await Permission.camera.status;
    File? imageTemporary;

    if (status.isDenied) {
      Permission.camera.request();
    } else {
      final img = await ImagePicker().pickImage(
        source: imageSource,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 800,
        imageQuality: 50,
      );
      if (img != null) {
        imageTemporary = File(img.path);
      }
    }

    return imageTemporary;
  }

  Future<String?> getImageString(imageSource) async {
    var status = await Permission.camera.status;
    String? string;
    if (status.isDenied) {
      Permission.camera.request();
    } else {
      final img = await ImagePicker().pickImage(source: imageSource);
      if (img != null) {
        string = img.path;
      }
    }

    return string;
  }
}
