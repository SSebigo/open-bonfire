import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/repositories/bonfire_repository.dart';
import 'package:bonfire/repositories/daily_quest_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/online_storage_repository.dart';
import 'package:bonfire/repositories/trophy_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/Paths.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time/time.dart';
import './bloc.dart';

class LightBonfireBloc extends Bloc<LightBonfireEvent, LightBonfireState> {
  final Geoflutterfire geo = Geoflutterfire();
  final BonfireRepository _bonfireRepository = BonfireRepository();
  final OnlineStorageRepository _onlineStorageRepository =
      OnlineStorageRepository();
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final DailyQuestRepository _dailyQuestRepository = DailyQuestRepository();
  final TrophyRepository _trophyRepository = TrophyRepository();

  @override
  LightBonfireState get initialState => InitialLightBonfireState();

  @override
  Stream<LightBonfireState> mapEventToState(
    LightBonfireEvent event,
  ) async* {
    if (event is OnLightBonfireFileClicked) {
      yield* _mapOnLightBonfireFileToState(event);
    }
    if (event is OnLightBonfireImageClicked) {
      yield* _mapOnLightBonfireImageToState(event);
    }
    if (event is OnLightBonfireTextClicked) {
      yield* _mapOnLightBonfireTextToState(event);
    }
    if (event is OnLightBonfireVideoClicked) {
      yield* _mapOnLightBonfireVideoToState(event);
    }
    if (event is OnImagePicked) {
      yield DisplayImagePreviewState(file: event.file);
    }
    if (event is OnVideoPicked) {
      yield DisplayVideoPreviewState(file: event.file);
    }
    if (event is OnFilePicked) {
      yield DisplayFilePreviewState(file: event.file);
    }
  }

  Stream<LightBonfireState> _mapOnLightBonfireFileToState(
      OnLightBonfireFileClicked event) async* {
    yield LightingBonfire();
    try {
      final Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final String url = await _onlineStorageRepository?.uploadFile(event.file,
          Paths.getAttachmentsPathByFileType(event.fileType) as String);
      final String sessionUid = _localStorageRepository
          ?.getUserSessionData(Constants.sessionUid) as String;

      final Bonfire bonfire = FileBonfire(
        fileUrl: url,
        fileName: event.fileName,
        description: event.description.trim(),
        id: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        expiresAt: (DateTime.now() + 1.days).millisecondsSinceEpoch,
        expired: false,
        authorUid: sessionUid,
        position: position,
        likes: <String>[],
        dislikes: <String>[],
        deleted: false,
        visibleBy: event.visibleBy,
        viewedBy: <String>[],
      );

      yield BonfireLit();

      // NOTE: update bonfire count for general count and file bonfire count
      await Future.wait([
        _bonfireRepository?.lightBonfire(bonfire),
        _userDataRepository?.updateBonfireCount(),
        _userDataRepository?.updateFileBonfireCount(),
      ]);

      yield* _updateUserExperienceAndLevel();

      await _trophyRepository?.updateTrophyProgress();
    } catch (error) {
      yield LightBonfireError(error: error);
    }
  }

  Stream<LightBonfireState> _mapOnLightBonfireImageToState(
      OnLightBonfireImageClicked event) async* {
    yield LightingBonfire();
    try {
      final Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final String url = await _onlineStorageRepository?.uploadFile(event.file,
          Paths.getAttachmentsPathByFileType(event.fileType) as String);
      final String sessionUid = _localStorageRepository
          ?.getUserSessionData(Constants.sessionUid) as String;

      final Bonfire bonfire = ImageBonfire(
        imageUrl: url,
        description: event.description.trim(),
        id: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        expiresAt: (DateTime.now() + 1.days).millisecondsSinceEpoch,
        expired: false,
        authorUid: sessionUid,
        position: position,
        likes: <String>[],
        dislikes: <String>[],
        deleted: false,
        visibleBy: event.visibleBy,
        viewedBy: <String>[],
      );

      yield BonfireLit();

      // NOTE: update bonfire count for general count and image bonfire count
      await Future.wait([
        _bonfireRepository?.lightBonfire(bonfire),
        _userDataRepository?.updateBonfireCount(),
        _userDataRepository?.updateImageBonfireCount(),
      ]);

      yield* _updateUserExperienceAndLevel();
    } catch (error) {
      yield LightBonfireError(error: error);
    }
  }

  Stream<LightBonfireState> _mapOnLightBonfireTextToState(
      OnLightBonfireTextClicked event) async* {
    yield LightingBonfire();
    try {
      final Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final String sessionUid = _localStorageRepository
          ?.getUserSessionData(Constants.sessionUid) as String;
      final Bonfire bonfire = TextBonfire(
        text: event.text.trim(),
        id: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        expiresAt: (DateTime.now() + 1.days).millisecondsSinceEpoch,
        expired: false,
        authorUid: sessionUid,
        position: position,
        likes: <String>[],
        dislikes: <String>[],
        deleted: false,
        visibleBy: event.visibleBy,
        viewedBy: <String>[],
      );

      yield BonfireLit();

      // NOTE: update bonfire count for general count and text bonfire count
      await Future.wait([
        _bonfireRepository?.lightBonfire(bonfire),
        _userDataRepository?.updateBonfireCount(),
        _userDataRepository?.updateTextBonfireCount(),
      ]);

      yield* _updateUserExperienceAndLevel();

      await _trophyRepository?.updateTrophyProgress();
    } catch (error) {
      yield LightBonfireError(error: error);
    }
  }

  Stream<LightBonfireState> _mapOnLightBonfireVideoToState(
      OnLightBonfireVideoClicked event) async* {
    yield LightingBonfire();
    try {
      final Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final String url = await _onlineStorageRepository?.uploadFile(event.file,
          Paths.getAttachmentsPathByFileType(event.fileType) as String);
      final String sessionUid = _localStorageRepository
          ?.getUserSessionData(Constants.sessionUid) as String;
      final Bonfire bonfire = VideoBonfire(
        videoUrl: url,
        description: event.description.trim(),
        id: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        expiresAt: (DateTime.now() + 1.days).millisecondsSinceEpoch,
        expired: false,
        authorUid: sessionUid,
        position: position,
        likes: <String>[],
        dislikes: <String>[],
        deleted: false,
        visibleBy: event.visibleBy,
        viewedBy: <String>[],
      );

      yield BonfireLit();

      // NOTE: update bonfire count for general count and video bonfire count
      await Future.wait([
        _bonfireRepository?.lightBonfire(bonfire),
        _userDataRepository?.updateBonfireCount(),
        _userDataRepository?.updateVideoBonfireCount(),
      ]);

      yield* _updateUserExperienceAndLevel();
    } catch (error) {
      yield LightBonfireError(error: error);
    }
  }

  Stream<LightBonfireState> _updateUserExperienceAndLevel() async* {
    bool dailyQuestCompleted = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;

    int experience = 1;

    if (dailyQuestCompleted == false) {
      // NOTE: check for progress in daily quest
      await _dailyQuestRepository?.updateDailyQuestProgress();

      // NOTE: update user daily quest if daily quest completed
      dailyQuestCompleted = _localStorageRepository
          ?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;

      if (dailyQuestCompleted == true) {
        await _userDataRepository?.updateDailyQuestStatus(dailyQuestCompleted);
        yield DailyQuestCompleted();

        final int dailyQuestExperience = _localStorageRepository
            ?.getDailyQuestData(Constants.dailyQuestExperience) as int;

        experience += dailyQuestExperience;
      }
    }

    final int currentUserExperience = _localStorageRepository
        ?.getUserSessionData(Constants.sessionExperience) as int;

    await _userDataRepository
        ?.updateExperience(currentUserExperience + experience);

    // NOTE: if experince > nextLevelExperience, update level and nextLevelExperience
    final bool updateLevel = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUpdateUserLevel) as bool;

    if (updateLevel == true) {
      final int currentUserLevel = _localStorageRepository
          ?.getUserSessionData(Constants.sessionLevel) as int;

      await Future.wait([
        _userDataRepository?.updateLevel(currentUserLevel + 1),
        _userDataRepository?.updateNextLevelExperience(currentUserLevel + 1),
      ]);
    }
  }
}
