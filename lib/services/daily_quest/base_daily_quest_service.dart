import 'package:bonfire/models/daily_quest.dart';
import 'package:bonfire/services/base_service.dart';

abstract class BaseDailyQuestService extends BaseService {
  Future<List<DailyQuest>> getDailyQuests();
  Future<DailyQuest> getRandomDailyQuest(String previousDailyQuestId);
  Future<DailyQuest> getDailyQuestById(String id);
  Future<void> updateDailyQuest();
  Future<void> updateDailyQuestById(
    int bonfireToLit,
    bool completed,
    int deadline,
    String id,
  );
  Future<void> nullifyDailyQuest();
  Future<void> updateDailyQuestProgress();
}
