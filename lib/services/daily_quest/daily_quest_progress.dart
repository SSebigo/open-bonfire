import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';

class DailyQuestProgress {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  Future<void> updateMasterOfBonfiresProgress() async {
    final int dayFileBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayFileBonfireCount) as int;
    final int dayImageBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayImageBonfireCount) as int;
    final int dayTextBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayTextBonfireCount) as int;
    final int dayVideoBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayVideoBonfireCount) as int;

    final int bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;

    final totalBonfireCount = dayFileBonfireCount +
        dayImageBonfireCount +
        dayTextBonfireCount +
        dayVideoBonfireCount;

    if (totalBonfireCount >= bonfireToLit) {
      await _localStorageRepository?.setDailyQuestData(
          Constants.dailyQuestCompleted, true);
    }
  }

  Future<void> updateMasterOfFilesProgress() async {
    final int dayFileBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayFileBonfireCount) as int;
    final int bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;

    if (dayFileBonfireCount >= bonfireToLit) {
      await _localStorageRepository?.setDailyQuestData(
          Constants.dailyQuestCompleted, true);
    }
  }

  Future<void> updateMasterOfImagesProgress() async {
    final int dayImageBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayImageBonfireCount) as int;
    final int bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;

    if (dayImageBonfireCount >= bonfireToLit) {
      await _localStorageRepository?.setDailyQuestData(
          Constants.dailyQuestCompleted, true);
    }
  }

  Future<void> updateMasterOfTextsProgress() async {
    final int dayTextBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayTextBonfireCount) as int;
    final int bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;

    if (dayTextBonfireCount >= bonfireToLit) {
      await _localStorageRepository?.setDailyQuestData(
          Constants.dailyQuestCompleted, true);
    }
  }

  Future<void> updateMasterOfVideosProgress() async {
    final int dayVideoBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayVideoBonfireCount) as int;
    final int bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;

    if (dayVideoBonfireCount >= bonfireToLit) {
      await _localStorageRepository?.setDailyQuestData(
          Constants.dailyQuestCompleted, true);
    }
  }
}
