import 'dart:io';

import 'package:bonfire/models/skin.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/services/skin/base_skin_service.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalSkinService extends BaseLocalSkinService {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  static final LocalSkinService _singleton = LocalSkinService._internal();

  LocalSkinService._internal();

  factory LocalSkinService() => _singleton;

  @override
  Future<String> createSkinFolderPath(String folderName) async {
    // Get Bonfire App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    // Bonfire Document Directory + folder(s) name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/skins/$folderName');

    // if folder already exists return path
    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    } else {
      // if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  @override
  Future<List<String>> getSkinsInFolder(String folderPath) async {
    final Directory dir = Directory(folderPath);
    final List<FileSystemEntity> entityList = dir.listSync();

    final List<String> fileNames = <String>[];
    entityList.forEach((e) async {
      final File file = File(e.path);
      final String filename = await _getFileNameWithExtension(file);
      fileNames.add(filename);
    });
    return fileNames;
  }

  Future<String> _getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return basename(file.path);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateSkin(Skin skin) async {
    final Map<String, String> skinToMap = skin.toMap();
    skinToMap.removeWhere((key, value) => key == 'id' || key == 'uniqueName');

    await _localStorageRepository?.setSkinData(Constants.skin, skinToMap);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
