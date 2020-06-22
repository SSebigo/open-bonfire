import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

abstract class LightBonfireEvent extends Equatable {
  const LightBonfireEvent();
}

class OnLightBonfireTextClicked extends LightBonfireEvent {
  final String text;
  final List<String> visibleBy;

  const OnLightBonfireTextClicked({
    @required this.text,
    @required this.visibleBy,
  });

  @override
  List<Object> get props => [text, visibleBy];
}

class OnLightBonfireImageClicked extends LightBonfireEvent {
  final File file;
  final FileType fileType;
  final String description;
  final List<String> visibleBy;

  const OnLightBonfireImageClicked({
    @required this.file,
    @required this.fileType,
    @required this.description,
    @required this.visibleBy,
  });

  @override
  List<Object> get props => [file, fileType, description, visibleBy];
}

class OnLightBonfireVideoClicked extends LightBonfireEvent {
  final File file;
  final FileType fileType;
  final String description;
  final List<String> visibleBy;

  const OnLightBonfireVideoClicked({
    @required this.file,
    @required this.fileType,
    @required this.description,
    @required this.visibleBy,
  });

  @override
  List<Object> get props => [file, fileType, description, visibleBy];
}

class OnLightBonfireFileClicked extends LightBonfireEvent {
  final File file;
  final FileType fileType;
  final String fileName;
  final String description;
  final List<String> visibleBy;

  const OnLightBonfireFileClicked({
    @required this.file,
    @required this.fileType,
    @required this.fileName,
    @required this.description,
    @required this.visibleBy,
  });

  @override
  List<Object> get props => [file, fileType, fileName, description, visibleBy];
}

class OnImagePicked extends LightBonfireEvent {
  final File file;

  const OnImagePicked({@required this.file});

  @override
  List<Object> get props => [file];
}

class OnVideoPicked extends LightBonfireEvent {
  final File file;

  const OnVideoPicked({@required this.file});

  @override
  List<Object> get props => [file];
}

class OnFilePicked extends LightBonfireEvent {
  final File file;

  const OnFilePicked({@required this.file});

  @override
  List<Object> get props => [file];
}
