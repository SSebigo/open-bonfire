import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LightBonfireState extends Equatable {
  const LightBonfireState();
}

class InitialLightBonfireState extends LightBonfireState {
  @override
  List<Object> get props => [];
}

class DisplayImagePreviewState extends LightBonfireState {
  final File file;

  const DisplayImagePreviewState({@required this.file});

  @override
  List<Object> get props => [file];
}

class DisplayVideoPreviewState extends LightBonfireState {
  final File file;

  const DisplayVideoPreviewState({@required this.file});

  @override
  List<Object> get props => [file];
}


class DisplayFilePreviewState extends LightBonfireState {
  final File file;

  const DisplayFilePreviewState({@required this.file});

  @override
  List<Object> get props => [file];
}

class LightingBonfire extends LightBonfireState {
  @override
  List<Object> get props => [];
}

class BonfireLit extends LightBonfireState {
  @override
  List<Object> get props => [];
}

class DailyQuestCompleted extends LightBonfireState {
  @override
  List<Object> get props => [];
}

class LightBonfireError extends LightBonfireState {
  final error;

  const LightBonfireError({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: $error';
}
