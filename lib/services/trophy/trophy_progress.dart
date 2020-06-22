import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';

class TrophyProgress {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();

  Future<void> updateTrophyAllIron(
    String trophyId, {
    int fileBonfireCount,
    int imageBonfireCount,
    int textBonfireCount,
    int videoBonfireCount,
  }) async {
    final int total = fileBonfireCount +
        imageBonfireCount +
        textBonfireCount +
        videoBonfireCount;

    if (total >= 10) {
      final List<Trophy> missingTrophies = List.from(_localStorageRepository
              ?.getUserSessionData(Constants.sessionMissingTrophies)
          as List<Trophy>);

      missingTrophies.removeWhere((trophy) => trophy.id == trophyId);

      await Future.wait([
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _userDataRepository?.updateTrophies(trophyId),
      ]);
    }
  }

  Future<void> updateTrophyAllBronze(
    String trophyId, {
    int fileBonfireCount,
    int imageBonfireCount,
    int textBonfireCount,
    int videoBonfireCount,
  }) async {
    final int total = fileBonfireCount +
        imageBonfireCount +
        textBonfireCount +
        videoBonfireCount;

    if (total >= 100) {
      final List<Trophy> missingTrophies = List.from(_localStorageRepository
              ?.getUserSessionData(Constants.sessionMissingTrophies)
          as List<Trophy>);

      missingTrophies.removeWhere((trophy) => trophy.id == trophyId);

      await Future.wait([
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _userDataRepository?.updateTrophies(trophyId),
      ]);
    }
  }

  Future<void> updateTrophyAllSilver(
    String trophyId, {
    int fileBonfireCount,
    int imageBonfireCount,
    int textBonfireCount,
    int videoBonfireCount,
  }) async {
    final int total = fileBonfireCount +
        imageBonfireCount +
        textBonfireCount +
        videoBonfireCount;

    if (total >= 1000) {
      final List<Trophy> missingTrophies = List.from(_localStorageRepository
              ?.getUserSessionData(Constants.sessionMissingTrophies)
          as List<Trophy>);

      missingTrophies.removeWhere((trophy) => trophy.id == trophyId);

      await Future.wait([
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _userDataRepository?.updateTrophies(trophyId),
      ]);
    }
  }

  Future<void> updateTrophyAllGold(
    String trophyId, {
    int fileBonfireCount,
    int imageBonfireCount,
    int textBonfireCount,
    int videoBonfireCount,
  }) async {
    final int total = fileBonfireCount +
        imageBonfireCount +
        textBonfireCount +
        videoBonfireCount;

    if (total >= 100000) {
      final List<Trophy> missingTrophies = List.from(_localStorageRepository
              ?.getUserSessionData(Constants.sessionMissingTrophies)
          as List<Trophy>);

      missingTrophies.removeWhere((trophy) => trophy.id == trophyId);

      await Future.wait([
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _userDataRepository?.updateTrophies(trophyId),
      ]);
    }
  }

  Future<void> updateTrophyAllPlatinum(
    String trophyId, {
    int fileBonfireCount,
    int imageBonfireCount,
    int textBonfireCount,
    int videoBonfireCount,
  }) async {
    final int total = fileBonfireCount +
        imageBonfireCount +
        textBonfireCount +
        videoBonfireCount;

    if (total >= 1000000) {
      final List<Trophy> missingTrophies = List.from(_localStorageRepository
              ?.getUserSessionData(Constants.sessionMissingTrophies)
          as List<Trophy>);

      missingTrophies.removeWhere((trophy) => trophy.id == trophyId);

      await Future.wait([
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _userDataRepository?.updateTrophies(trophyId),
      ]);
    }
  }

  Future<void> updateTrophyAllDiamond(
    String trophyId, {
    int fileBonfireCount,
    int imageBonfireCount,
    int textBonfireCount,
    int videoBonfireCount,
  }) async {
    final int total = fileBonfireCount +
        imageBonfireCount +
        textBonfireCount +
        videoBonfireCount;

    if (total >= 1000000000) {
      final List<Trophy> missingTrophies = List.from(_localStorageRepository
              ?.getUserSessionData(Constants.sessionMissingTrophies)
          as List<Trophy>);

      missingTrophies.removeWhere((trophy) => trophy.id == trophyId);

      await Future.wait([
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _userDataRepository?.updateTrophies(trophyId),
      ]);
    }
  }
}
