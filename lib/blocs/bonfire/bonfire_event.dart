import 'package:bonfire/models/bonfire.dart';
import 'package:equatable/equatable.dart';

abstract class BonfireEvent extends Equatable {
  const BonfireEvent();
}

class EVTOnGoBackClicked extends BonfireEvent {
  @override
  List<Object> get props => [];
}

class EVTOnNavigateClicked extends BonfireEvent {
  final ImageBonfire bonfire;

  const EVTOnNavigateClicked({this.bonfire});

  @override
  List<Object> get props => [bonfire];
}

class EVTOnDownloadFileClicked extends BonfireEvent {
  final String fileUrl;
  final String errorMessage;

  const EVTOnDownloadFileClicked({this.fileUrl, this.errorMessage});

  @override
  List<Object> get props => [fileUrl, errorMessage];
}

class EVTOnBonfireLiked extends BonfireEvent {
  final String id;
  final String sessionUid;
  final List<String> likes;
  final List<String> dislikes;

  const EVTOnBonfireLiked({this.id, this.sessionUid, this.likes, this.dislikes});

  @override
  List<Object> get props => [id, sessionUid, likes, dislikes];
}

class EVTOnBonfireDisliked extends BonfireEvent {
  final String id;
  final String sessionUid;
  final List<String> likes;
  final List<String> dislikes;

  const EVTOnBonfireDisliked({this.id, this.sessionUid, this.likes, this.dislikes});

  @override
  List<Object> get props => [id, sessionUid, likes, dislikes];
}

class EVTOnFollowClicked extends BonfireEvent {
  final String followingUid;
  final String errorMessage;

  const EVTOnFollowClicked({this.followingUid, this.errorMessage});

  @override
  List<Object> get props => [followingUid, errorMessage];
}

class EVTOnUnfollowClicked extends BonfireEvent {
  final String unfollowingUid;

  const EVTOnUnfollowClicked({this.unfollowingUid});

  @override
  List<Object> get props => [unfollowingUid];
}

class EVTOnFetchBonfireUserDetails extends BonfireEvent {
  final String authorUid;

  const EVTOnFetchBonfireUserDetails({this.authorUid});

  @override
  List<Object> get props => [authorUid];
}
