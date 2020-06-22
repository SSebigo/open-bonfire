import 'package:bonfire/models/daily_quest.dart';
import 'package:bonfire/models/penalty.dart';
import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/services/storage/base_storage_service.dart';
import 'package:bonfire/services/storage/local_storage_service.dart';

class LocalStorageRepository {
  final BaseLocalStorageService _localStorageService = LocalStorageService();

  static final LocalStorageRepository _singleton =
      LocalStorageRepository._internal();

  LocalStorageRepository._internal();

  factory LocalStorageRepository() => _singleton;

  Future<void> initLocalStorageService() =>
      _localStorageService.initLocalStorageService();

  Future<void> setUserSession(UserSession userSession) =>
      _localStorageService.setUserSession(userSession);

  Future<void> clearUserSession() => _localStorageService.clearUserSession();

  Future<void> setDailyQuest(
    DailyQuest dailyQuest, {
    int bonfireToLit,
    bool completed,
    int deadline,
    String previousDailyQuestId,
  }) =>
      _localStorageService.setDailyQuest(
        dailyQuest,
        bonfireToLit: bonfireToLit,
        completed: completed,
        deadline: deadline,
        previousDailyQuestId: previousDailyQuestId,
      );

  Future<void> clearDailyQuest() => _localStorageService.clearDailyQuest();

  Future<void> setPenalty(
    Penalty penalty, {
    int deadline,
    String previousPenaltyId,
  }) =>
      _localStorageService.setPenalty(
        penalty,
        deadline: deadline,
        previousPenaltyId: previousPenaltyId,
      );

  Future<void> clearPenalty() => _localStorageService.clearPenalty();

  Future<void> setUserSessionData(String key, dynamic value) =>
      _localStorageService.setUserSessionData(key, value);

  Future<void> clearUserSessionData(String key) =>
      _localStorageService.clearUserSessionData(key);

  dynamic getUserSessionData(String key) =>
      _localStorageService.getUserSessionData(key);

  Future<void> setSessionConfigData(String key, dynamic value) =>
      _localStorageService.setSessionConfigData(key, value);

  Future<void> clearSessionConfigData(String key) =>
      _localStorageService.clearSessionConfigData(key);

  dynamic getSessionConfigData(String key) =>
      _localStorageService.getSessionConfigData(key);

  Future<void> setDailyQuestData(String key, dynamic value) =>
      _localStorageService.setDailyQuestData(key, value);

  Future<void> clearDailyQuestData(String key) =>
      _localStorageService.clearDailyQuestData(key);

  dynamic getDailyQuestData(String key) =>
      _localStorageService.getDailyQuestData(key);

  Future<void> setPenaltyData(String key, dynamic value) =>
      _localStorageService.setPenaltyData(key, value);

  Future<void> clearPenaltyData(String key) =>
      _localStorageService.clearPenaltyData(key);

  dynamic getPenaltyData(String key) =>
      _localStorageService.getPenaltyData(key);

  Future<void> setSkinData(String key, dynamic value) =>
      _localStorageService.setSkinData(key, value);

  Future<void> clearSkinData(String key) =>
      _localStorageService.clearSkinData(key);

  dynamic getSkinData(String key) => _localStorageService.getSkinData(key);

  Future<void> setTrophiesData(String key, dynamic value) =>
      _localStorageService.setTrophiesData(key, value);

  Future<void> clearTrophiesData(String key) =>
      _localStorageService.clearTrophiesData(key);

  dynamic getTrophiesData(String key) =>
      _localStorageService.getTrophiesData(key);
}
