import 'dart:io';

import 'package:bonfire/models/daily_quest.dart';
import 'package:bonfire/models/penalty.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:hive/hive.dart';
import 'package:bonfire/services/storage/base_storage_service.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService extends BaseLocalStorageService {
  final Logger logger = Logger();
  Box userSessionBox;
  Box sessionConfigBox;
  Box dailyQuestBox;
  Box penaltyBox;
  Box skinBox;
  Box trophiesBox;

  static final LocalStorageService _singleton = LocalStorageService._internal();

  LocalStorageService._internal();

  factory LocalStorageService() => _singleton;

  @override
  Future<void> initLocalStorageService() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/db';
    await Directory(dirPath).create(recursive: true);

    Hive.registerAdapter(TrophyAdapter());

    Hive.init(dirPath);

    userSessionBox = await Hive.openBox('userSessionBox');
    sessionConfigBox = await Hive.openBox('sessionConfigBox');
    dailyQuestBox = await Hive.openBox('dailyQuestBox');
    penaltyBox = await Hive.openBox('penaltyBox');
    skinBox = await Hive.openBox('skinBox');
    trophiesBox = await Hive.openBox('trophiesBox');

    if (_singleton.getSessionConfigData(Constants.configFirstRun) == null ||
        _singleton.getSessionConfigData(Constants.configFirstRun) as bool) {
      await Future.wait([
        _singleton.setSessionConfigData(Constants.configDarkMode, false),
        _singleton.setSessionConfigData(Constants.configImageCompression, true),
        _singleton.setSessionConfigData(Constants.configFirstRun, false),
      ]);

      final String currentLocale =
          (await Devicelocale.currentLocale).split(RegExp('[_-]'))[0];
      await _singleton.setSessionConfigData(
          Constants.configLocale, currentLocale);
    }
  }

  @override
  Future<void> setUserSession(UserSession userSession) async {
    final Map<dynamic, dynamic> entries = <dynamic, dynamic>{};

    entries[Constants.sessionBonfireCount] = userSession.bonfireCount;
    entries[Constants.sessionCountry] = userSession.country;
    entries[Constants.sessionCreatedAt] = userSession.createdAt;
    entries[Constants.sessionDailyQuest] = userSession.dailyQuest;
    entries[Constants.sessionDayFileBonfireCount] =
        userSession.dayFileBonfireCount;
    entries[Constants.sessionDayImageBonfireCount] =
        userSession.dayImageBonfireCount;
    entries[Constants.sessionDayTextBonfireCount] =
        userSession.dayTextBonfireCount;
    entries[Constants.sessionDayVideoBonfireCount] =
        userSession.dayVideoBonfireCount;
    entries[Constants.sessionEmail] = userSession.email;
    entries[Constants.sessionExperience] = userSession.experience;
    entries[Constants.sessionFileBonfireCount] = userSession.fileBonfireCount;
    entries[Constants.sessionFollowing] = userSession.following;
    entries[Constants.sessionImageBonfireCount] = userSession.imageBonfireCount;
    entries[Constants.sessionIsAnonymous] = userSession.isAnonymous;
    entries[Constants.sessionLevel] = userSession.level;
    entries[Constants.sessionMissingTrophies] = userSession.missingTrophies;
    entries[Constants.sessionName] = userSession.name;
    entries[Constants.sessionNextLevelExperience] =
        userSession.nextLevelExperience;
    entries[Constants.sessionPassword] = userSession.password;
    entries[Constants.sessionPenalty] = userSession.penalty;
    entries[Constants.sessionProfilePictureUrl] = userSession.photoUrl;
    entries[Constants.sessionSkinUniqueName] = userSession.skinUniqueName;
    entries[Constants.sessionTextBonfireCount] = userSession.textBonfireCount;
    entries[Constants.sessionUid] = userSession.uid;
    entries[Constants.sessionUpdatedAt] = userSession.updatedAt;
    entries[Constants.sessionUsername] = userSession.username;
    entries[Constants.sessionVideoBonfireCount] = userSession.videoBonfireCount;

    await userSessionBox.putAll(entries);
  }

  @override
  Future<void> clearUserSession() async {
    await userSessionBox.deleteAll([
      Constants.sessionBonfireCount,
      Constants.sessionCountry,
      Constants.sessionCreatedAt,
      Constants.sessionDailyQuest,
      Constants.sessionDayFileBonfireCount,
      Constants.sessionDayImageBonfireCount,
      Constants.sessionDayTextBonfireCount,
      Constants.sessionDayVideoBonfireCount,
      Constants.sessionEmail,
      Constants.sessionExperience,
      Constants.sessionFileBonfireCount,
      Constants.sessionFollowing,
      Constants.sessionImageBonfireCount,
      Constants.sessionIsAnonymous,
      Constants.sessionLevel,
      Constants.sessionMissingTrophies,
      Constants.sessionName,
      Constants.sessionNextLevelExperience,
      Constants.sessionPassword,
      Constants.sessionPenalty,
      Constants.sessionProfilePictureUrl,
      Constants.sessionSkinUniqueName,
      Constants.sessionTextBonfireCount,
      Constants.sessionUid,
      Constants.sessionUpdatedAt,
      Constants.sessionUsername,
      Constants.sessionVideoBonfireCount
    ]);
  }

  @override
  Future<void> setDailyQuest(
    DailyQuest dailyQuest, {
    int bonfireToLit,
    bool completed,
    int deadline,
    String previousDailyQuestId,
  }) async {
    final Map<dynamic, dynamic> entries = <dynamic, dynamic>{};

    entries[Constants.dailyQuestBonfireToLit] = bonfireToLit;
    entries[Constants.dailyQuestCompleted] = completed;
    entries[Constants.dailyQuestDeadline] = deadline;
    entries[Constants.dailyQuestDescription] = dailyQuest.description;
    entries[Constants.dailyQuestExperience] =
        dailyQuest.experience ?? bonfireToLit;
    entries[Constants.dailyQuestId] = dailyQuest.id;
    entries[Constants.dailyQuestPreviousDailyQuestId] = previousDailyQuestId;
    entries[Constants.dailyQuestProgressive] = dailyQuest.progressive;
    entries[Constants.dailyQuestTitle] = dailyQuest.title;
    entries[Constants.dailyQuestUniqueName] = dailyQuest.uniqueName;

    await dailyQuestBox.putAll(entries);
  }

  @override
  Future<void> clearDailyQuest() async {
    await dailyQuestBox.deleteAll([
      Constants.dailyQuestBonfireToLit,
      Constants.dailyQuestCompleted,
      Constants.dailyQuestDeadline,
      Constants.dailyQuestDescription,
      Constants.dailyQuestExperience,
      Constants.dailyQuestId,
      Constants.dailyQuestPreviousDailyQuestId,
      Constants.dailyQuestProgressive,
      Constants.dailyQuestTitle,
      Constants.dailyQuestUniqueName,
    ]);
  }

  @override
  Future<void> setPenalty(
    Penalty penalty, {
    int deadline,
    String previousPenaltyId,
  }) async {
    final Map<dynamic, dynamic> entries = <dynamic, dynamic>{};

    entries[Constants.penaltyDeadline] = deadline;
    entries[Constants.penaltyDescription] = penalty.description;
    entries[Constants.penaltyId] = penalty.id;
    entries[Constants.penaltyPreviousPenaltyId] = previousPenaltyId;
    entries[Constants.penaltyTitle] = penalty.title;
    entries[Constants.penaltyUniqueName] = penalty.uniqueName;

    await penaltyBox.putAll(entries);
  }

  @override
  Future<void> clearPenalty() async {
    await penaltyBox.deleteAll([
      Constants.penaltyDeadline,
      Constants.penaltyDescription,
      Constants.penaltyId,
      Constants.penaltyPreviousPenaltyId,
      Constants.penaltyTitle,
      Constants.penaltyUniqueName,
    ]);
  }

  @override
  Future<void> setUserSessionData(String key, dynamic value) async {
    await userSessionBox.put(key, value);
  }

  @override
  Future<void> clearUserSessionData(String key) async {
    await userSessionBox.delete(key);
  }

  @override
  dynamic getUserSessionData(String key) {
    return userSessionBox.get(key);
  }

  @override
  Future<void> setSessionConfigData(String key, dynamic value) async {
    await sessionConfigBox.put(key, value);
  }

  @override
  Future<void> clearSessionConfigData(String key) async {
    await sessionConfigBox.delete(key);
  }

  @override
  dynamic getSessionConfigData(String key) {
    return sessionConfigBox.get(key);
  }

  @override
  Future<void> setDailyQuestData(String key, dynamic value) async {
    await dailyQuestBox.put(key, value);
  }

  @override
  Future<void> clearDailyQuestData(String key) {
    return dailyQuestBox.delete(key);
  }

  @override
  dynamic getDailyQuestData(String key) {
    return dailyQuestBox.get(key);
  }

  @override
  Future<void> setPenaltyData(String key, dynamic value) {
    return penaltyBox.put(key, value);
  }

  @override
  Future<void> clearPenaltyData(String key) {
    return penaltyBox.delete(key);
  }

  @override
  dynamic getPenaltyData(String key) {
    return penaltyBox.get(key);
  }

  @override
  Future<void> setSkinData(String key, dynamic value) {
    return skinBox.put(key, value);
  }

  @override
  Future<void> clearSkinData(String key) {
    return skinBox.delete(key);
  }

  @override
  dynamic getSkinData(String key) {
    return skinBox.get(key);
  }

  @override
  Future<void> setTrophiesData(String key, dynamic value) {
    return trophiesBox.put(key, value);
  }

  @override
  Future<void> clearTrophiesData(String key) {
    return trophiesBox.delete(key);
  }

  @override
  dynamic getTrophiesData(String key) {
    return trophiesBox.get(key);
  }

  @override
  void dispose() {
    Hive.close();
  }
}
