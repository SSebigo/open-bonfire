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
  final Logger logger = Logger();

  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();
  final LocalSkinRepository _localSkinRepository = LocalSkinRepository();
  final OnlineSkinRepository _onlineSkinRepository = OnlineSkinRepository();
  final TrophyRepository _trophyRepository = TrophyRepository();
  final BackgroundTask _backgroundTask = BackgroundTask();

  SplashBloc() : super(InitialSplashState());

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
    if (event is EVTOnAuthenticate) {
      yield* _mapOnAuthenticateToState();
    }
  }

  Stream<SplashState> _mapOnResquestPermissionsToState() async* {
    yield STEPermissionsRequestPending();
    try {
      final PermissionStatus status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        add(EVTOnInitializeDownloadManager());
      } else if (status == PermissionStatus.denied) {
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
      add(EVTOnInitializeBackgroundTaskManager());
    } catch (error) {
      yield STESplashError(error: error);
    }
  }

  Stream<SplashState> _mapOnInitializeBackgroundTaskManagerToState() async* {
    yield STEInitializingBackgroundTaskManager();
    try {
      BackgroundFetch.configure(BackgroundFetchConfig(minimumFetchInterval: 15), (String taskId) async {
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
      add(EVTOnInitializeLocale());
    } catch (error) {
      yield STESplashError(error: error);
    }
  }

  Stream<SplashState> _mapOnInitializeLocaleToState() async* {
    yield STEInitializingLocale();
    try {
      final String _locale = _localStorageRepository?.getSessionConfigData(Constants.configLocale) as String;

      await Jiffy.locale(_locale);
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
        final String skinUniqueName =
            _localStorageRepository?.getUserSessionData(Constants.sessionSkinUniqueName) as String;

        final Skin skinDetails = await _onlineSkinRepository?.getSkinDetails(skinUniqueName);

        await _localSkinRepository?.updateSkin(skinDetails);

        final bool isAnonymous = _localStorageRepository?.getUserSessionData(Constants.sessionIsAnonymous) as bool;

        if (isAnonymous) {
          yield STENavigationToMap();
        } else {
          final bool isProfileComplete = await _userDataRepository?.isProfileComplete();
          if (isProfileComplete) {
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

            await Future.wait([
              _localStorageRepository?.setTrophiesData(Constants.trophies, trophies),
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
