import 'dart:io';

import 'package:bonfire/services/storage/base_storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class FirebaseStorageService extends BaseOnlineStorageService {
  final Logger logger = Logger();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static final FirebaseStorageService _singleton =
      FirebaseStorageService._internal();

  FirebaseStorageService._internal();

  factory FirebaseStorageService() => _singleton;

  @override
  Future<String> uploadFile(File file, String path) async {
    final String fileName = basename(file.path);
    final StorageReference reference = _firebaseStorage
        .ref()
        .child('$path/${DateTime.now().millisecondsSinceEpoch}-$fileName');
    final StorageUploadTask uploadTask = reference.putFile(file);
    final StorageTaskSnapshot result = await uploadTask.onComplete;
    final String url = await result.ref.getDownloadURL() as String;
    return url;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
