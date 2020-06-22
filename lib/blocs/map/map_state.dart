import 'package:bonfire/models/bonfire.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class InitialMapState extends MapState {
  @override
  List<Object> get props => [];
}

class NavigatingState extends MapState {
  @override
  List<Object> get props => [];
}

class NavigationToLightBonfireFileState extends MapState {
  @override
  List<Object> get props => [];
}

class NavigationToLightBonfireImageState extends MapState {
  @override
  List<Object> get props => [];
}

class NavigationToLightBonfireVideoState extends MapState {
  @override
  List<Object> get props => [];
}

class NavigationToLightBonfireTextState extends MapState {
  @override
  List<Object> get props => [];
}

// class ARComingState extends MapState {
//   @override
//   List<Object> get props => [];
// }

class FetchedPositionState extends MapState {
  final Position position;

  const FetchedPositionState({@required this.position});

  @override
  List<Object> get props => [position];
}

class FetchingBonfiresState extends MapState {
  @override
  List<Object> get props => [];
}

class FetchedBonfiresState extends MapState {
  final List<Bonfire> bonfires;

  const FetchedBonfiresState({@required this.bonfires});

  @override
  List<Object> get props => [bonfires];
}

class SittingByTheFireState extends MapState {
  @override
  List<Object> get props => [];
}

class NavigateToBonfireState extends MapState {
  final Bonfire bonfire;

  const NavigateToBonfireState({@required this.bonfire});

  @override
  List<Object> get props => [bonfire];
}

class MapErrorState extends MapState {
  final error;

  const MapErrorState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: $error';
}
