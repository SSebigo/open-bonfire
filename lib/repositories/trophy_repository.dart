import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/services/trophy/base_trophy_service.dart';
import 'package:bonfire/services/trophy/firebase_trophy_service.dart';

class TrophyRepository {
  final BaseTrophyService _trophyService = FirebaseTrophyService();

  static final TrophyRepository _singleton = TrophyRepository._internal();

  TrophyRepository._internal();

  factory TrophyRepository() => _singleton;

  Future<List<Trophy>> getTrophies() => _trophyService.getTrophies();

  Future<void> updateTrophyProgress() => _trophyService.updateTrophyProgress();
}
