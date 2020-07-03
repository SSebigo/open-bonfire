import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:bloc/bloc.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/repositories/daily_quest_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/online_storage_repository.dart';
import 'package:bonfire/repositories/penalty_repository.dart';
import 'package:bonfire/repositories/trophy_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:bonfire/utils/validators.dart';
import 'package:time/time.dart';
import './bloc.dart';

class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final OnlineStorageRepository _onlineStorageRepository = OnlineStorageRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();
  final DailyQuestRepository _dailyQuestRepository = DailyQuestRepository();
  final TrophyRepository _trophyRepository = TrophyRepository();
  final PenaltyRepository _penaltyRepository = PenaltyRepository();

  CompleteProfileBloc() : super(InitialCompleteProfileState());

  @override
  Stream<CompleteProfileState> mapEventToState(
    CompleteProfileEvent event,
  ) async* {
    if (event is OnUsernameChanged) {
      yield TextFieldChangedState();
      yield UsernameValidityState(isUsernameValid: Validators.username(event.username));
    }
    if (event is OnNameChanged) {
      yield TextFieldChangedState();
      yield NameValidityState(isNameValid: Validators.name(event.name));
    }
    if (event is OnSaveProfileClicked) {
      yield* _mapOnSaveProfileClickedToState(event);
    }
  }

  Stream<CompleteProfileState> _mapOnSaveProfileClickedToState(OnSaveProfileClicked event) async* {
    yield SavingProfileState();
    try {
      await _userDataRepository?.checkUsernameAvailability(event.username);
      final String profilePictureUrl = event.pictureFile == null
          ? ''
          : await _onlineStorageRepository?.uploadFile(event.pictureFile, Paths.profilePicturePath);
      await _userDataRepository?.saveProfileDetails(
          profilePictureUrl: profilePictureUrl,
          name: event.name,
          username: event.username.replaceAll(' ', '_').toLowerCase());

      final List<Trophy> trophies = await _trophyRepository?.getTrophies();

      final List<String> userTrophies =
          _localStorageRepository?.getUserSessionData(Constants.sessionTrophies)?.cast<String>() as List<String>;

      final List<Trophy> missingTrophies = trophies.where((trophy) {
        if (userTrophies == null) {
          return true;
        } else {
          return userTrophies.contains(trophy);
        }
      }).toList();

      // NOTE set random daily quest
      await Future.wait([
        _localStorageRepository?.setTrophiesData(Constants.trophies, trophies),
        _userDataRepository?.updateMissingTrophies(missingTrophies),
        _dailyQuestRepository?.updateDailyQuest(),
        _penaltyRepository?.nullifyPenalty(),
      ]);

      await _trophyRepository?.updateTrophyProgress();

      final int bonfireToLit = _localStorageRepository?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;
      final bool completed = _localStorageRepository?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;
      final String dailyQuestId = _localStorageRepository?.getDailyQuestData(Constants.dailyQuestId) as String;
      final int deadline = _localStorageRepository?.getDailyQuestData(Constants.dailyQuestDeadline) as int;

      // NOTE send new daily quest data to user account in database
      await Future.wait([
        _userDataRepository?.updateDailyQuest(bonfireToLit, completed, dailyQuestId, deadline),
        _userDataRepository?.nullifyPenalty(),
        _userDataRepository?.zerofyAllBonfireTypesCount(),
      ]);

      // NOTE: set background to update as soon as deadline reached
      BackgroundFetch.scheduleTask(TaskConfig(
        taskId: Constants.updateDailyQuestOrPenalty,
        delay: 1.days.inMilliseconds,
      ));

      yield ProfileSavedState();
    } catch (error) {
      yield SaveProfileFailedState(error: error);
    }
  }
}
