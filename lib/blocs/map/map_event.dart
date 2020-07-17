import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:bonfire/models/bonfire.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class OnFetchInitialPositionEvent extends MapEvent {
  @override
  List<Object> get props => [];
}

class OnFetchPositionEvent extends MapEvent {
  @override
  List<Object> get props => [];
}

class OnReceivedPositionEvent extends MapEvent {
  final Position position;

  const OnReceivedPositionEvent({this.position});

  @override
  List<Object> get props => [position];
}

class OnFetchBonfiresEvent extends MapEvent {
  final Position position;

  const OnFetchBonfiresEvent({this.position});

  @override
  List<Object> get props => [position];
}

class OnReceivedBonfiresEvent extends MapEvent {
  final List<Bonfire> bonfires;

  const OnReceivedBonfiresEvent({this.bonfires});

  @override
  List<Object> get props => [bonfires];
}

class OnLightBonfireClickedEvent extends MapEvent {
  final int type;

  const OnLightBonfireClickedEvent({@required this.type});

  @override
  List<Object> get props => [type];
}

class OnBonfireClickedEvent extends MapEvent {
  final Bonfire bonfire;

  const OnBonfireClickedEvent({@required this.bonfire});

  @override
  List<Object> get props => [bonfire];
}
