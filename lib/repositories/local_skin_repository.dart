import 'package:bonfire/models/skin.dart';
import 'package:bonfire/services/skin/base_skin_service.dart';
import 'package:bonfire/services/skin/local_skin_service.dart';

class LocalSkinRepository {
  final BaseLocalSkinService _localSkinService = LocalSkinService();

  static final LocalSkinRepository _singleton = LocalSkinRepository._internal();

  LocalSkinRepository._internal();

  factory LocalSkinRepository() => _singleton;

  Future<String> createSkinFolderPath(String folderName) =>
      _localSkinService.createSkinFolderPath(folderName);

  Future<List<String>> getSkinsInFolder(String folderPath) =>
      _localSkinService.getSkinsInFolder(folderPath);

  Future<void> updateSkin(Skin skin) => _localSkinService.updateSkin(skin);
}
