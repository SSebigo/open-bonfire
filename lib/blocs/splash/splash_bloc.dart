import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:bloc/bloc.dart';
import 'package:bonfire/background_tasks.dart';
import 'package:bonfire/models/skin.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/repositories/authentication_repository.dart';
import 'package:bonfire/repositories/local_skin_repository.dart';
import 'package:bonfire/repositories/online_skin_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/trophy_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import './bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final PermissionHandler _permissionHandler = PermissionHandler();

  final Logger logger = Logger();

  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final LocalSkinRepository _localSkinRepository = LocalSkinRepository();
  final OnlineSkinRepository _onlineSkinRepository = OnlineSkinRepository();
  final TrophyRepository _trophyRepository = TrophyRepository();
  final BackgroundTask _backgroundTask = BackgroundTask();

  @override
  SplashState get initialState => InitialSplashState();

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is EVTOnRequestPermissions) {
      yield* _mapOnResquestPermissionsToState();
    }
    if (event is EVTOnInitializeDownloadManager) {
      yield* _mapOnInitializeDownloadManagerToState();
    }
    if (event is EVTOnInitializeBackgroundTaskManager) {
      yield* _mapOnInitializeBackgroundTaskManagerToState();
    }
    if (event is EVTOnBackgroundTaskUpdateDailyQuestOrPenalty) {
      yield STEBackgroundTaskUpdatingDailyQuestOrPenalty();
      try {
        await _backgroundTask.updateDailyQuestOrPenalty();
        yield STEBackgroundTaskDailyQuestOrPenaltyUpdated();
      } catch (error) {
        yield STESplashError(error: error);
      }
    }
    if (event is EVTOnInitializeLocale) {
      yield* _mapOnInitializeLocaleToState();
    }
    // if (event is EVTOnInitializeSkinsManager) {
    //   yield* _mapOnInitializeSkinsManagerToState();
    // }
    if (event is EVTOnAuthenticate) {
      yield* _mapOnAuthenticateToState();
    }
  }

  Stream<SplashState> _mapOnResquestPermissionsToState() async* {
    yield STEPermissionsRequestPending();
    try {
      final result = await _permissionHandler
          .requestPermissions([PermissionGroup.location]);
      if (result[PermissionGroup.location] == PermissionStatus.granted) {
        add(EVTOnInitializeDownloadManager());
      } else if (PermissionStatus.granted == result[PermissionGroup.location]) {
        yield STEPermissionsRequestDenied();
      }
    } catch (error) {
      yield STESplashError(error: error);
    }
  }

  Stream<SplashState> _mapOnInitializeDownloadManagerToState() async* {
    yield STEInitializingDownloadManager();
    try {
      await FlutterDownloader.initialize();
      yield STEDownloadManagerInitialized();
      add(EVTOnInitializeBackgroundTaskManager());
    } catch (error) {
      yield STESplashError(error: error);
    }
  }

  Stream<SplashState> _mapOnInitializeBackgroundTaskManagerToState() async* {
    yield STEInitializingBackgroundTaskManager();
    try {
      BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: false,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY,
          ), (String taskId) async {
        // This is the fetch-event callback.

        // Use a switch statement to route task-handling.
        switch (taskId) {
          case Constants.updateDailyQuestOrPenalty:
            add(EVTOnBackgroundTaskUpdateDailyQuestOrPenalty());
            break;
          default:
        }
        // Finish, providing received taskId.
        BackgroundFetch.finish(taskId);
      });
      yield STEBackgroundTaskManagerInitialized();
      add(EVTOnInitializeLocale());
    } catch (error) {
      yield STESplashError(error: error);
    }
  }

  Stream<SplashState> _mapOnInitializeLocaleToState() async* {
    yield STEInitializingLocale();
    try {
      final String _locale = _localStorageRepository
          ?.getSessionConfigData(Constants.configLocale) as String;

      await Jiffy.locale(_locale);
      yield STELocaleInitialized();
      add(EVTOnAuthenticate());
    } catch (error) {
      yield STESplashError(error: error);
    }
  }

  Stream<SplashState> _mapOnAuthenticateToState() async* {
    yield STELocalStorageLoading();
    try {
      final isSignedIn = await _authenticationRepository?.isSignedIn();
      if (isSignedIn) {
        // update skin
        final String skinUniqueName = _localStorageRepository
            ?.getUserSessionData(Constants.sessionSkinUniqueName) as String;

        final Skin skinDetails =
            await _onlineSkinRepository?.getSkinDetails(skinUniqueName);

        await _localSkinRepository?.updateSkin(skinDetails);

        final bool isAnonymous = _localStorageRepository
            ?.getUserSessionData(Constants.sessionIsAnonymous) as bool;

        if (isAnonymous) {
          yield STENavigationToMap();
        } else {
          final bool isProfileComplete =
              await _userDataRepository?.isProfileComplete();
          if (isProfileComplete) {
            final List<Trophy> trophies =
                await _trophyRepository?.getTrophies();

            final List<String> userTrophies = _localStorageRepository
                ?.getUserSessionData(Constants.sessionTrophies) as List<String>;

            final List<Trophy> missingTrophies = trophies.where((trophy) {
              if (userTrophies == null) {
                return true;
              } else {
                return userTrophies.contains(trophy);
              }
            }).toList();

            await Future.wait([
              _localStorageRepository?.setTrophiesData(
                  Constants.trophies, trophies),
              _userDataRepository?.updateMissingTrophies(missingTrophies),
              _backgroundTask.updateDailyQuestOrPenalty(),
            ]);

            await _trophyRepository?.updateTrophyProgress();

            yield STENavigationToMap();
          } else {
            yield STENavigationToCompleteProfile();
          }
        }
      } else {
        yield STENavigationToAnonymousSignIn();
      }
    } catch (error) {
      yield STESplashError(error: error);
    }
  }
}
