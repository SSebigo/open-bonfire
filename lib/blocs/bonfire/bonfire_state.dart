import 'package:bonfire/models/bonfire_user_details.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

abstract class BonfireState extends Equatable {
  const BonfireState();
}

class InitialBonfireState extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEGoingBack extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEWentBack extends BonfireState {
  @override
  List<Object> get props => [];
}

class STENavigating extends BonfireState {
  @override
  List<Object> get props => [];
}

class STENavigated extends BonfireState {
  final Color color;

  const STENavigated({this.color});

  @override
  List<Object> get props => [color];
}

class STEDownloadingFile extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEFileDownloaded extends BonfireState {
  final String savePath;
  final FileType fileType;

  const STEFileDownloaded({@required this.savePath, this.fileType});

  @override
  List<Object> get props => [savePath, fileType];
}

class STEBonfireUpdating extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEBonfireUpdated extends BonfireState {
  final List<String> likes;
  final List<String> dislikes;

  const STEBonfireUpdated({this.likes, this.dislikes});

  @override
  List<Object> get props => [likes, dislikes];
}

class STEAddingFollowing extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEFollowingAdded extends BonfireState {
  final bool isFollowing;

  const STEFollowingAdded({this.isFollowing});

  @override
  List<Object> get props => [isFollowing];
}

class STERemovingFollowing extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEFollowingRemoved extends BonfireState {
  final bool isFollowing;

  const STEFollowingRemoved({this.isFollowing});

  @override
  List<Object> get props => [isFollowing];
}

class STEFetchingBonfireUserDetails extends BonfireState {
  @override
  List<Object> get props => [];
}

class STEFetchedBonfireUserDetails extends BonfireState {
  final BonfireUserDetails userDetails;

  const STEFetchedBonfireUserDetails({this.userDetails});

  @override
  List<Object> get props => [userDetails];
}

class BonfireErrorState extends BonfireState {
  final error;

  const BonfireErrorState({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'error: $error';
}
