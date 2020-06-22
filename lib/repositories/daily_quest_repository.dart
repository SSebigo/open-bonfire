import 'package:bonfire/models/daily_quest.dart';
import 'package:bonfire/services/daily_quest/base_daily_quest_service.dart';
import 'package:bonfire/services/daily_quest/firebase_daily_quest_service.dart';

class DailyQuestRepository {
  final BaseDailyQuestService _dailyQuestService = FirebaseDailyQuestService();

  static final DailyQuestRepository _singleton =
      DailyQuestRepository._internal();

  DailyQuestRepository._internal();

  factory DailyQuestRepository() => _singleton;

  Future<List<DailyQuest>> getDailyQuests() =>
      _dailyQuestService.getDailyQuests();

  Future<DailyQuest> getRandomDailyQuest(String previousDailyQuestId) =>
      _dailyQuestService.getRandomDailyQuest(previousDailyQuestId);

  Future<DailyQuest> getDailyQuestById(String id) =>
      _dailyQuestService.getDailyQuestById(id);

  Future<void> updateDailyQuest() => _dailyQuestService.updateDailyQuest();

  Future<void> updateDailyQuestById(
    int bonfireToLit,
    bool completed,
    int deadline,
    String id,
  ) =>
      _dailyQuestService.updateDailyQuestById(
        bonfireToLit,
        completed,
        deadline,
        id,
      );

  Future<void> nullifyDailyQuest() => _dailyQuestService.nullifyDailyQuest();

  Future<void> updateDailyQuestProgress() =>
      _dailyQuestService.updateDailyQuestProgress();
}
