import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CompleteProfileEvent extends Equatable {
  const CompleteProfileEvent();
}

class OnPhotoChanged extends CompleteProfileEvent {
  final String photoUrl;

  const OnPhotoChanged({@required this.photoUrl});

  @override
  List<Object> get props => [photoUrl];

  @override
  String toString() => 'photoUrl: $photoUrl';
}

class OnUsernameChanged extends CompleteProfileEvent {
  final String username;

  const OnUsernameChanged({@required this.username});

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'username: $username';
}

class OnNameChanged extends CompleteProfileEvent {
  final String name;

  const OnNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'name: $name';
}

class OnSaveProfileClicked extends CompleteProfileEvent {
  final File pictureFile;
  final String username;
  final String name;

  const OnSaveProfileClicked({
    this.pictureFile,
    this.username,
    this.name,
  });

  @override
  List<Object> get props => [pictureFile, username, name];

  @override
  String toString() => 'pictureFile: $pictureFile, username: $username, name: $name';
}
