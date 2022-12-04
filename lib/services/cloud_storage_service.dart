import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class CloudStorageService extends GetxService {
  static CloudStorageService get to => Get.find();

  Future<String> uploadPhoto(File file) async {
    final extension = path.extension(file.path);
    final uid = Uuid().v4();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('recipe-photos')
        .child('/photo-$uid.$extension');
    await ref.putData(await file.readAsBytes());
    return ref.getDownloadURL();
  }
}
