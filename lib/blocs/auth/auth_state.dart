import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class InitialAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class NavigatingState extends AuthState {
  @override
  List<Object> get props => [];
}

class NavigateToMapState extends AuthState {
  @override
  List<Object> get props => [];
}

class NavigateToCompleteProfileState extends AuthState {
  @override
  List<Object> get props => [];
}

class TextFieldChangedState extends AuthState {
  @override
  List<Object> get props => [];
}

class EmailValidityState extends AuthState {
  final bool isEmailValid;

  const EmailValidityState({@required this.isEmailValid});

  @override
  List<Object> get props => [isEmailValid];
}

class PasswordValidityState extends AuthState {
  final bool isPasswordValid;

  const PasswordValidityState({@required this.isPasswordValid});

  @override
  List<Object> get props => [isPasswordValid];
}

class ConfirmPasswordValidityState extends AuthState {
  final bool isConfirmPasswordValid;

  const ConfirmPasswordValidityState({@required this.isConfirmPasswordValid});

  @override
  List<Object> get props => [isConfirmPasswordValid];
}

class SigningInAnonymously extends AuthState {
  @override
  List<Object> get props => [];
}

class SignedInAnonymously extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggingInState extends AuthState {
  @override
  List<Object> get props => [];
}

class SendingMailState extends AuthState {
  @override
  List<Object> get props => [];
}

class SendMailSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class ConvertingAccountState extends AuthState {
  @override
  List<Object> get props => [];
}

class AccountConvertedState extends AuthState {
  @override
  List<Object> get props => [];
}

class ResetLinkSentState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggingOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final error;

  const AuthErrorState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: $error';
}
