import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import './bloc.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  @override
  DarkModeState get initialState => InitialDarkModeState();

  @override
  Stream<DarkModeState> mapEventToState(
    DarkModeEvent event,
  ) async* {
    if (event is OnDarkModeToggled) {
      _localStorageRepository?.setSessionConfigData(
          Constants.configDarkMode, !event.darkMode);
      yield DarkModeChanged(darkMode: !event.darkMode);
    }
  }
}
