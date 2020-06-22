import 'dart:io';

import 'package:bonfire/models/daily_quest.dart';
import 'package:bonfire/models/penalty.dart';
import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/services/base_service.dart';

abstract class BaseOnlineStorageService extends BaseService {
  Future<String> uploadFile(File file, String path);
}

abstract class BaseLocalStorageService extends BaseService {
  Future<void> initLocalStorageService();

  Future<void> setUserSession(UserSession userSession);
  Future<void> clearUserSession();

  Future<void> setDailyQuest(
    DailyQuest dailyQuest, {
    bool completed,
    int bonfireToLit,
    int deadline,
    String previousDailyQuestId,
  });
  Future<void> clearDailyQuest();

  Future<void> setPenalty(
    Penalty penalty, {
    int deadline,
    String previousPenaltyId,
  });
  Future<void> clearPenalty();

  Future<void> setUserSessionData(String key, dynamic value);
  Future<void> clearUserSessionData(String key);
  dynamic getUserSessionData(String key);

  Future<void> setSessionConfigData(String key, dynamic value);
  Future<void> clearSessionConfigData(String key);
  dynamic getSessionConfigData(String key);

  Future<void> setDailyQuestData(String key, dynamic value);
  Future<void> clearDailyQuestData(String key);
  dynamic getDailyQuestData(String key);

  Future<void> setPenaltyData(String key, dynamic value);
  Future<void> clearPenaltyData(String key);
  dynamic getPenaltyData(String key);

  Future<void> setSkinData(String key, dynamic value);
  Future<void> clearSkinData(String key);
  dynamic getSkinData(String key);

  Future<void> setTrophiesData(String key, dynamic value);
  Future<void> clearTrophiesData(String key);
  dynamic getTrophiesData(String key);
}
