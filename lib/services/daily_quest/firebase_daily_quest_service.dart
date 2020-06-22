import 'dart:math';

import 'package:bonfire/models/daily_quest.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/services/daily_quest/base_daily_quest_service.dart';
import 'package:bonfire/services/daily_quest/daily_quest_progress.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/methods.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time/time.dart';

class FirebaseDailyQuestService extends BaseDailyQuestService {
  final Firestore _firestore = Firestore.instance;
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final DailyQuestProgress _dailyQuestProgress = DailyQuestProgress();

  static final FirebaseDailyQuestService _singleton =
      FirebaseDailyQuestService._internal();

  FirebaseDailyQuestService._internal();

  factory FirebaseDailyQuestService() => _singleton;

  @override
  Future<List<DailyQuest>> getDailyQuests() async {
    final CollectionReference dailyQuestsReference =
        _firestore.collection(Paths.dailyQuestsPath);
    final querySnapshot = await dailyQuestsReference.getDocuments();

    final List<DailyQuest> dailyQuests = <DailyQuest>[];
    querySnapshot.documents
        .forEach((doc) => dailyQuests.add(DailyQuest.fromFirestore(doc)));
    return dailyQuests;
  }

  @override
  Future<DailyQuest> getRandomDailyQuest(String previousDailyQuestId) async {
    final int sessionLevel = _localStorageRepository
        ?.getUserSessionData(Constants.sessionLevel) as int;

    final List<DailyQuest> allDailyQuest = await getDailyQuests();
    final List<DailyQuest> filterDailyQuests = allDailyQuest.length > 1
        ? allDailyQuest
            .where((item) =>
                item.id != previousDailyQuestId &&
                (sessionLevel >= item.minLevel &&
                    sessionLevel <= item.maxLevel))
            .toList()
        : allDailyQuest;

    final Random rnd = Random();
    final int idx = rnd.nextInt(filterDailyQuests.length);
    final DailyQuest rDailyQuest = filterDailyQuests[idx];
    return rDailyQuest;
  }

  @override
  Future<DailyQuest> getDailyQuestById(String id) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(Paths.dailyQuestsPath)
        .where('id', isEqualTo: id)
        .getDocuments();
    final DocumentSnapshot doc = querySnapshot.documents[0];
    return DailyQuest.fromFirestore(doc);
  }

  @override
  Future<void> updateDailyQuest() async {
    final String previousDailyQuestId = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestPreviousDailyQuestId) as String;
    final DailyQuest dailyQuest =
        await getRandomDailyQuest(previousDailyQuestId);

    await _localStorageRepository?.setDailyQuest(
      dailyQuest,
      bonfireToLit: dailyQuest.progressive == true
          ? nextQuestBonfireToLitAndExperience(_localStorageRepository
              ?.getUserSessionData(Constants.sessionLevel) as int)
          : null,
      completed: false,
      deadline: (DateTime.now() + 1.days).millisecondsSinceEpoch,
      previousDailyQuestId: dailyQuest.id,
    );
  }

  @override
  Future<void> updateDailyQuestById(
    int bonfireToLit,
    bool completed,
    int deadline,
    String id,
  ) async {
    final DailyQuest dailyQuest = await getDailyQuestById(id);

    await _localStorageRepository?.setDailyQuest(
      dailyQuest,
      bonfireToLit: bonfireToLit,
      completed: completed,
      deadline: deadline,
      previousDailyQuestId: id,
    );
  }

  @override
  Future<void> nullifyDailyQuest() async {
    await _localStorageRepository?.setDailyQuest(
        DailyQuest(
            description: null,
            experience: null,
            id: null,
            title: null,
            uniqueName: null),
        completed: null,
        deadline: null,
        previousDailyQuestId: null);
  }

  @override
  Future<void> updateDailyQuestProgress() async {
    final String dailyQuestUniqueName = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestUniqueName) as String;

    switch (dailyQuestUniqueName) {
      case 'master_of_bonfires':
        await _dailyQuestProgress.updateMasterOfBonfiresProgress();
        break;
      case 'master_of_files':
        await _dailyQuestProgress.updateMasterOfFilesProgress();
        break;
      case 'master_of_images':
        await _dailyQuestProgress.updateMasterOfImagesProgress();
        break;
      case 'master_of_texts':
        await _dailyQuestProgress.updateMasterOfTextsProgress();
        break;
      case 'master_of_videos':
        await _dailyQuestProgress.updateMasterOfVideosProgress();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
