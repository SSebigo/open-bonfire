import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class OnSplashLaunched extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnRequestPermissions extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnInitializeDownloadManager extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnInitializeBackgroundTaskManager extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnBackgroundTaskUpdateDailyQuestOrPenalty extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnInitializeLocale extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnInitializeSkinsManager extends SplashEvent {
  @override
  List<Object> get props => [];
}

class EVTOnAuthenticate extends SplashEvent {
  @override
  List<Object> get props => [];
}
