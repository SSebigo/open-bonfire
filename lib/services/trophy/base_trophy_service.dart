import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/services/base_service.dart';

abstract class BaseTrophyService extends BaseService {
  Future<List<Trophy>> getTrophies();
  Future<void> updateTrophyProgress();
}
