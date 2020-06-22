import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/models/follow.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();
}

class InitialMyProfileState extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEGoingBack extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEWentBack extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEUpdatingProfilePicture extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEProfilePictureUpdated extends MyProfileState {
  final String profilePictureUrl;

  const STEProfilePictureUpdated({@required this.profilePictureUrl});

  @override
  List<Object> get props => [profilePictureUrl];
}

class STEFetchingUserBonfires extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEFetchedUserBonfires extends MyProfileState {
  final List<Bonfire> bonfires;

  const STEFetchedUserBonfires({@required this.bonfires});

  @override
  List<Object> get props => [bonfires];
}

class STEFetchingFollowingDetails extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEFetchedFollowingDetails extends MyProfileState {
  final List<Follow> following;

  const STEFetchedFollowingDetails({@required this.following});

  @override
  List<Object> get props => [following];
}

class STERemovingFollowing extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STEFollowingRemoved extends MyProfileState {
  final List<Follow> following;

  const STEFollowingRemoved({@required this.following});

  @override
  List<Object> get props => [following];
}

class STEFetchingTrophies extends MyProfileState {
  @override
  List<Object> get props => [];
}

class STETrophiesFetched extends MyProfileState {
  final List<Trophy> trophies;

  const STETrophiesFetched({this.trophies});

  @override
  List<Object> get props => [trophies];
}

class MyProfileErrorState extends MyProfileState {
  final error;

  const MyProfileErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}
