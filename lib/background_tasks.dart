import 'package:background_fetch/background_fetch.dart';
import 'package:bonfire/repositories/daily_quest_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/penalty_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:time/time.dart';

class BackgroundTask {
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final DailyQuestRepository _dailyQuestRepository = DailyQuestRepository();
  final PenaltyRepository _penaltyRepository = PenaltyRepository();

  Future<void> updateDailyQuestOrPenalty() async {
    // NOTE: check if session daily quest or penalty set
    final Map<String, dynamic> dailyQuest = _localStorageRepository
        ?.getUserSessionData(
          Constants.sessionDailyQuest,
        )
        ?.cast<String, dynamic>() as Map<String, dynamic>;
    final Map<String, dynamic> penalty = _localStorageRepository
        ?.getUserSessionData(
          Constants.sessionPenalty,
        )
        ?.cast<String, dynamic>() as Map<String, dynamic>;

    // NOTE: check if user already ahd daily quest or penalty in progress
    if (dailyQuest != null || penalty != null) {
      if (dailyQuest != null) {
        final int deadline = dailyQuest['deadline'] as int;

        if (DateTime.now().millisecondsSinceEpoch >= deadline) {
          final bool completed = dailyQuest['completed'] as bool;

          if (completed == true) {
            await _updateDailyQuest();
          } else {
            await _updatePenalty();
          }
        } else {
          await Future.wait([
            _dailyQuestRepository?.updateDailyQuestById(
                dailyQuest['bonfireToLit'] as int,
                dailyQuest['completed'] as bool,
                dailyQuest['deadline'] as int,
                dailyQuest['id'] as String),
            _penaltyRepository?.nullifyPenalty(),
            _userDataRepository?.nullifyPenalty(),
          ]);

          final DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
              dailyQuest['deadline'] as int);
          final DateTime now = DateTime.now();
          final Duration difference = deadline.difference(now);

          // NOTE: set background to update as soon as deadline reached
          BackgroundFetch.scheduleTask(TaskConfig(
            taskId: Constants.updateDailyQuestOrPenalty,
            delay: difference.inMilliseconds,
          ));
        }
      } else {
        final int deadline = penalty['deadline'] as int;

        if (DateTime.now().millisecondsSinceEpoch >= deadline) {
          await _updateDailyQuest();
        } else {
          await Future.wait([
            _penaltyRepository?.updatePenaltyById(
                penalty['deadline'] as int, penalty['id'] as String),
            _dailyQuestRepository?.nullifyDailyQuest(),
            _userDataRepository?.nullifyDailyQuest(),
          ]);

          final DateTime dtDeadline =
              DateTime.fromMillisecondsSinceEpoch(deadline);
          final DateTime now = DateTime.now();
          final Duration difference = dtDeadline.difference(now);

          // NOTE: set background to update as soon as deadline reached
          BackgroundFetch.scheduleTask(TaskConfig(
            taskId: Constants.updateDailyQuestOrPenalty,
            delay: difference.inMilliseconds,
          ));
        }
      }
    } else {
      await _updateDailyQuest();
    }
  }

  Future<void> _updateDailyQuest() async {
    // NOTE: set random daily quest
    await Future.wait([
      _dailyQuestRepository?.updateDailyQuest(),
      _penaltyRepository?.nullifyPenalty(),
    ]);

    final int bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;
    final bool completed = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;
    final String dailyQuestId = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestId) as String;
    final int deadline = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestDeadline) as int;

    // NOTE: send new daily quest data to user account in database
    await Future.wait([
      _userDataRepository?.updateDailyQuest(
          bonfireToLit, completed, dailyQuestId, deadline),
      _userDataRepository?.nullifyPenalty(),
      _userDataRepository?.zerofyAllBonfireTypesCount(),
    ]);

    // NOTE: set background to update as soon as deadline reached
    BackgroundFetch.scheduleTask(TaskConfig(
      taskId: Constants.updateDailyQuestOrPenalty,
      delay: 1.days.inMilliseconds,
    ));
  }

  Future<void> _updatePenalty() async {
    // NOTE: set random penalty
    await Future.wait([
      _penaltyRepository?.updatePenalty(),
      _dailyQuestRepository?.nullifyDailyQuest(),
    ]);

    final String penaltyId =
        _localStorageRepository?.getPenaltyData(Constants.penaltyId) as String;
    final int deadline = _localStorageRepository
        ?.getPenaltyData(Constants.penaltyDeadline) as int;

    // NOTE: send new penalty data to user account in database
    await Future.wait([
      _userDataRepository?.updatePenalty(deadline, penaltyId),
      _userDataRepository?.nullifyDailyQuest(),
      _userDataRepository?.zerofyAllBonfireTypesCount(),
    ]);

    // NOTE: set background to update as soon as deadline reached
    BackgroundFetch.scheduleTask(TaskConfig(
      taskId: Constants.updateDailyQuestOrPenalty,
      delay: 4.hours.inMilliseconds,
    ));
  }
}
