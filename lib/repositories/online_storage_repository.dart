import 'dart:io';

import 'package:bonfire/services/storage/base_storage_service.dart';
import 'package:bonfire/services/storage/firebase_storage_service.dart';

class OnlineStorageRepository {
  final BaseOnlineStorageService _onlineStorageService = FirebaseStorageService();

  static final OnlineStorageRepository _singleton =
      OnlineStorageRepository._internal();

  OnlineStorageRepository._internal();

  factory OnlineStorageRepository() => _singleton;

  Future<String> uploadFile(File file, String path) =>
      _onlineStorageService.uploadFile(file, path);
}
