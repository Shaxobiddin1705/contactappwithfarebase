import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreService{

  static final _storage = FirebaseStorage.instance.ref();
  static const String folder = 'contactImages';

  static Future<String?> uploadImage(File _image) async{
    String? url;
    String imgName = "image_" + DateTime.now().toString();
    Reference fireBaseStorageRef = _storage.child(folder).child(imgName);
    await fireBaseStorageRef.putFile(_image).then((value) async {
      if (value.metadata != null) {
        final String downloadUrl = await value.ref.getDownloadURL();
        url = downloadUrl;
      } else {
        url = null;
      }
    });
    return url;
  }

  static void deleteImage(String url) async {
    FirebaseStorage.instance.refFromURL(url).delete();
  }
}