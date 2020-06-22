import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class OnModifyNameClicked extends SettingsEvent {
  final String name;
  final String password;
  final String errorMessage;

  const OnModifyNameClicked({
    @required this.name,
    @required this.password,
    @required this.errorMessage,
  });

  @override
  List<Object> get props => [name, password, errorMessage];
}

class OnModifyEmailClicked extends SettingsEvent {
  final String email;
  final String password;
  final String errorMessage;

  const OnModifyEmailClicked(
      {@required this.email,
      @required this.password,
      @required this.errorMessage});

  @override
  List<Object> get props => [email, password, errorMessage];
}

class OnModifyPasswordClicked extends SettingsEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;
  final String errorMessage;

  const OnModifyPasswordClicked({
    @required this.currentPassword,
    @required this.newPassword,
    @required this.newPasswordConfirmation,
    @required this.errorMessage,
  });

  @override
  List<Object> get props =>
      [currentPassword, newPassword, newPasswordConfirmation, errorMessage];
}

class OnNameChanged extends SettingsEvent {
  final String name;

  const OnNameChanged({@required this.name});

  @override
  List<Object> get props => [name];
}

class OnEmailChanged extends SettingsEvent {
  final String email;

  const OnEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class OnPasswordChanged extends SettingsEvent {
  final String password;

  const OnPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class OnReportProblemClicked extends SettingsEvent {
  final String body;

  const OnReportProblemClicked({@required this.body});

  @override
  List<Object> get props => [body];
}

class OnGiveFeedbackClicked extends SettingsEvent {
  final String body;

  const OnGiveFeedbackClicked({@required this.body});

  @override
  List<Object> get props => [body];
}

class OnLogoutClicked extends SettingsEvent {
  @override
  List<Object> get props => [];
}
