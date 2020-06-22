import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bonfire/background_tasks.dart';
import 'package:bonfire/models/skin.dart';
import 'package:bonfire/repositories/authentication_repository.dart';
import 'package:bonfire/repositories/local_skin_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/online_skin_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Logger logger = Logger();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final LocalSkinRepository _localSkinRepository = LocalSkinRepository();
  final OnlineSkinRepository _onlineSkinRepository = OnlineSkinRepository();
  final BackgroundTask _backgroundTask = BackgroundTask();

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is OnSignInAnonymouslyClicked) {
      yield SigningInAnonymously();
      try {
        await _authenticationRepository?.signInAnonymously();

        final String skinUniqueName = _localStorageRepository
            ?.getUserSessionData(Constants.sessionSkinUniqueName) as String;

        final Skin skinDetails =
            await _onlineSkinRepository?.getSkinDetails(skinUniqueName);

        await _localSkinRepository?.updateSkin(skinDetails);

        yield SignedInAnonymously();
      } catch (error) {
        yield AuthErrorState(error: error);
      }
    }
    if (event is OnEmailChanged) {
      yield TextFieldChangedState();
      yield EmailValidityState(isEmailValid: Validators.email(event.email));
    }
    if (event is OnPasswordChanged) {
      yield TextFieldChangedState();
      yield PasswordValidityState(
          isPasswordValid: Validators.password(event.password));
    }
    if (event is OnConfirmPasswordChanged) {
      yield TextFieldChangedState();
      yield ConfirmPasswordValidityState(
          isConfirmPasswordValid: event.confirmPassword == event.password);
    }
    if (event is OnSignInClicked) {
      yield* _mapOnSignInClickedToState(event);
    }
    if (event is OnSignUpClicked) {
      yield* _mapOnSignUpClickedToState(event);
    }
    if (event is OnResetPasswordClicked) {
      try {
        await _authenticationRepository?.resetPassword(event.email);
        yield ResetLinkSentState();
      } catch (error) {
        yield AuthErrorState(error: error);
      }
    }
    if (event is OnLogoutClicked) {
      yield LoggingOutState();
      try {
        await _authenticationRepository?.signOut();
        yield LoggedOutState();
      } catch (error) {
        yield AuthErrorState(error: error);
      }
    }
  }

  Stream<AuthState> _mapOnSignInClickedToState(
    OnSignInClicked event,
  ) async* {
    yield LoggingInState();
    try {
      await _authenticationRepository?.signInWithEmail(
          event.email, event.password);

      final String skinUniqueName = _localStorageRepository
          ?.getUserSessionData(Constants.sessionSkinUniqueName) as String;

      final Skin skinDetails =
          await _onlineSkinRepository?.getSkinDetails(skinUniqueName);

      await _localSkinRepository?.updateSkin(skinDetails);

      final bool isProfileComplete =
          await _userDataRepository?.isProfileComplete();
      if (isProfileComplete == true) {
        await _backgroundTask.updateDailyQuestOrPenalty();
        yield NavigateToMapState();
      } else {
        yield NavigateToCompleteProfileState();
      }
    } catch (error) {
      yield AuthErrorState(error: error);
    }
  }

  Stream<AuthState> _mapOnSignUpClickedToState(
    OnSignUpClicked event,
  ) async* {
    final bool isAnonymous = _localStorageRepository
        ?.getUserSessionData(Constants.sessionIsAnonymous) as bool;
    yield isAnonymous != null && isAnonymous
        ? ConvertingAccountState()
        : SendingMailState();
    if (isAnonymous != null && isAnonymous) {
      try {
        final FirebaseUser firebaseUser = await _authenticationRepository
            .convertUserWithEmail(event.email, event.password);
        await _userDataRepository?.saveDetailsFromAuth(firebaseUser);
        yield AccountConvertedState();
      } catch (error) {
        yield AuthErrorState(error: error);
      }
    } else {
      try {
        final FirebaseUser firebaseUser = await _authenticationRepository
            .signUpWithEmail(event.email, event.password);
        await _userDataRepository?.saveDetailsFromAuth(firebaseUser);
        yield SendMailSuccessState();
      } catch (error) {
        yield AuthErrorState(error: error);
      }
    }
  }
}
