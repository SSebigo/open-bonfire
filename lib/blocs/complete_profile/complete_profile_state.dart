import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CompleteProfileState extends Equatable {
  const CompleteProfileState();
}

class InitialCompleteProfileState extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class TextFieldChangedState extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class UsernameValidityState extends CompleteProfileState {
  final bool isUsernameValid;

  const UsernameValidityState({@required this.isUsernameValid});

  @override
  List<Object> get props => [isUsernameValid];
}

class NameValidityState extends CompleteProfileState {
  final bool isNameValid;

  const NameValidityState({@required this.isNameValid});

  @override
  List<Object> get props => [isNameValid];
}

class SavingProfileState extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class ProfileSavedState extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class SaveProfileFailedState extends CompleteProfileState {
  final error;

  const SaveProfileFailedState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: $error';
}
