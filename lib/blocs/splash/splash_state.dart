import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class InitialSplashState extends SplashState {
  @override
  List<Object> get props => [];
}

class STEPermissionsRequestPending extends SplashState {
  @override
  List<Object> get props => [];
}

class STEPermissionsRequestDenied extends SplashState {
  @override
  List<Object> get props => [];
}

class STELocalStorageLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class STENavigationToAnonymousSignIn extends SplashState {
  @override
  List<Object> get props => [];
}

class STENavigationToMap extends SplashState {
  @override
  List<Object> get props => [];
}

class STENavigationToCompleteProfile extends SplashState {
  @override
  List<Object> get props => [];
}

class STEInitializingDownloadManager extends SplashState {
  @override
  List<Object> get props => [];
}

class STEInitializingBackgroundTaskManager extends SplashState {
  @override
  List<Object> get props => [];
}

class STEBackgroundTaskUpdatingDailyQuestOrPenalty extends SplashState {
  @override
  List<Object> get props => [];
}

class STEBackgroundTaskDailyQuestOrPenaltyUpdated extends SplashState {
  @override
  List<Object> get props => [];
}

class STEInitializingLocale extends SplashState {
  @override
  List<Object> get props => [];
}

class STEInitializingSkins extends SplashState {
  @override
  List<Object> get props => [];
}

class STESplashError extends SplashState {
  final error;

  const STESplashError({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: $error';
}
