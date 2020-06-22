import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class OnAuthLaunched extends AuthEvent {
  @override
  List<Object> get props => [];
}

class OnEmailChanged extends AuthEvent {
  final String email;

  const OnEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class OnPasswordChanged extends AuthEvent {
  final String password;

  const OnPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class OnConfirmPasswordChanged extends AuthEvent {
  final String password;
  final String confirmPassword;

  const OnConfirmPasswordChanged({@required this.password, @required this.confirmPassword});

  @override
  List<Object> get props => [password, confirmPassword];
}

class OnSignInAnonymouslyClicked extends AuthEvent {
  @override
  List<Object> get props => [];
}

class OnSignInClicked extends AuthEvent {
  final String email;
  final String password;

  const OnSignInClicked({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class OnSignUpClicked extends AuthEvent {
  final String email;
  final String password;

  const OnSignUpClicked({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class OnResetPasswordClicked extends AuthEvent {
  final String email;

  const OnResetPasswordClicked({@required this.email});

  @override
  List<Object> get props => [email];
}

class OnLogoutClicked extends AuthEvent {
  @override
  List<Object> get props => [];
}
