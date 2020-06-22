import 'dart:io';
import 'package:bonfire/models/bonfire.dart';
import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();
}

class EVTOnGoBackClicked extends MyProfileEvent {
  @override
  List<Object> get props => [];
}

class EVTOnProfilePictureClicked extends MyProfileEvent {
  final File file;

  const EVTOnProfilePictureClicked({@required this.file});

  @override
  List<Object> get props => [file];
}

class EVTOnFetchUserBonfires extends MyProfileEvent {
  @override
  List<Object> get props => [];
}

class EVTOnReceivedUserBonfires extends MyProfileEvent {
  final List<Bonfire> bonfires;

  const EVTOnReceivedUserBonfires({@required this.bonfires});

  @override
  List<Object> get props => [bonfires];
}

class EVTOnFetchFollowingDetails extends MyProfileEvent {
  final List<String> following;

  const EVTOnFetchFollowingDetails({@required this.following});

  @override
  List<Object> get props => [following];
}

class EVTOnUnfollowClicked extends MyProfileEvent {
  final String unfollowingUid;

  const EVTOnUnfollowClicked({@required this.unfollowingUid});

  @override
  List<Object> get props => [unfollowingUid];
}

class EVTOnFetchTrophies extends MyProfileEvent {
  @override
  List<Object> get props => [];
}
