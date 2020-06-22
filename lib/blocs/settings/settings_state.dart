import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class InitialSettingsState extends SettingsState {
  @override
  List<Object> get props => [];
}

class ModifyingFieldState extends SettingsState {
  @override
  List<Object> get props => [];
}

class FieldModifiedState extends SettingsState {
  @override
  List<Object> get props => [];
}

class LoggingOutState extends SettingsState {
  @override
  List<Object> get props => [];
}

class LoggedOutState extends SettingsState {
  @override
  List<Object> get props => [];
}

class TextFieldChangedState extends SettingsState {
  @override
  List<Object> get props => [];
}

class ReportingProblemState extends SettingsState {
  @override
  List<Object> get props => [];
}

class ProblemReportedState extends SettingsState {
  @override
  List<Object> get props => [];
}

class GivingFeedbackState extends SettingsState {
  @override
  List<Object> get props => [];
}

class FeedbackGivenState extends SettingsState {
  @override
  List<Object> get props => [];
}

class NameValidityState extends SettingsState {
  final bool isNameValid;

  const NameValidityState({@required this.isNameValid});

  @override
  List<Object> get props => [isNameValid];
}

class EmailValidityState extends SettingsState {
  final bool isEmailValid;

  const EmailValidityState({@required this.isEmailValid});

  @override
  List<Object> get props => [isEmailValid];
}

class PasswordValidityState extends SettingsState {
  final bool isPasswordValid;

  const PasswordValidityState({@required this.isPasswordValid});

  @override
  List<Object> get props => [isPasswordValid];
}

class SettingsFailedState extends SettingsState {
  final error;

  const SettingsFailedState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: ${error.message}';
}
