import 'package:bonfire/models/skin.dart';
import 'package:bonfire/services/base_service.dart';

abstract class BaseLocalSkinService extends BaseService {
  Future<String> createSkinFolderPath(String folderName);
  Future<List<String>> getSkinsInFolder(String folderName);
  Future<void> updateSkin(Skin skin);
}

abstract class BaseOnlineSkinService extends BaseService {
  Future<Skin> getSkinDetails(String skinUniqueName);
}
