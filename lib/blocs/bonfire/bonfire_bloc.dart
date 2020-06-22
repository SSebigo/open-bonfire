import 'dart:async';
import 'dart:ui' as Ui;

import 'package:bloc/bloc.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:flutter/src/widgets/image.dart' as DartImage;

import 'package:bonfire/models/bonfire_user_details.dart';
import 'package:bonfire/models/user_data_type.dart';
import 'package:bonfire/repositories/bonfire_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/exceptions.dart';
import 'package:bonfire/utils/methods.dart';

import './bloc.dart';

class BonfireBloc extends Bloc<BonfireEvent, BonfireState> {
  final BonfireRepository _bonfireRepository = BonfireRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  @override
  BonfireState get initialState => InitialBonfireState();

  @override
  Stream<BonfireState> mapEventToState(
    BonfireEvent event,
  ) async* {
    if (event is EVTOnGoBackClicked) {
      yield STEGoingBack();
      yield STEWentBack();
    }
    if (event is EVTOnNavigateClicked) {
      yield STENavigating();
      try {
        final DartImage.ImageProvider imageProvider =
            DartImage.NetworkImage(event.bonfire.imageUrl);
        final Ui.Image image = await getImageFromProvider(imageProvider);
        final color = await getColorFromImage(image);
        final Ui.Color rgbaColor = Ui.Color.fromRGBO(
            color[0] as int, color[1] as int, color[2] as int, 1.0);

        yield STENavigated(color: rgbaColor);
      } catch (error) {
        yield BonfireErrorState(error: error);
      }
    }
    if (event is EVTOnDownloadFileClicked) {
      yield* _mapOnDownloadFileClickedToState(event);
    }
    if (event is EVTOnBonfireLiked) {
      yield* _mapOnBonfireLikedToState(event);
    }
    if (event is EVTOnBonfireDisliked) {
      yield* _mapOnBonfireDislikedToState(event);
    }
    if (event is EVTOnFollowClicked) {
      yield* _mapOnFollowClickedToState(event);
    }
    if (event is EVTOnUnfollowClicked) {
      yield* _mapOnUnfollowClickedToState(event);
    }
    if (event is EVTOnFetchBonfireUserDetails) {
      yield* _mapOnFetchBonfireUserDetailsToState(event);
    }
  }

  Stream<BonfireState> _mapOnDownloadFileClickedToState(
      EVTOnDownloadFileClicked event) async* {
    yield STEDownloadingFile();
    try {
      final String taskId = await downloadFile(event.fileUrl);
      if (taskId == null) {
        yield BonfireErrorState(
          error: DownloadFailedException(event.errorMessage),
        );
      } else {
        yield STEFileDownloaded(savePath: taskId);
      }
    } catch (error) {
      yield BonfireErrorState(error: error);
    }
  }

  Stream<BonfireState> _mapOnBonfireLikedToState(
      EVTOnBonfireLiked event) async* {
    yield STEBonfireUpdating();
    try {
      final List<String> likes = List<String>.from(event.likes);
      final List<String> dislikes = List<String>.from(event.dislikes);

      if (!likes.contains(event.sessionUid)) {
        likes.add(event.sessionUid);
      }
      if (dislikes.contains(event.sessionUid)) {
        dislikes.remove(event.sessionUid);
      }

      yield STEBonfireUpdated(likes: likes, dislikes: dislikes);

      Future.wait([
        _bonfireRepository?.updateBonfireRating(event.id, likes, dislikes),
        _bonfireRepository?.updateBonfireExpirationDate(event.id, 1, 0),
      ]);
    } catch (error) {
      yield BonfireErrorState(error: error);
    }
  }

  Stream<BonfireState> _mapOnBonfireDislikedToState(
      EVTOnBonfireDisliked event) async* {
    yield STEBonfireUpdating();
    try {
      final List<String> likes = List<String>.from(event.likes);
      final List<String> dislikes = List<String>.from(event.dislikes);

      if (!dislikes.contains(event.sessionUid)) {
        dislikes.add(event.sessionUid);
      }
      if (likes.contains(event.sessionUid)) {
        likes.remove(event.sessionUid);
      }

      yield STEBonfireUpdated(likes: likes, dislikes: dislikes);

      Future.wait([
        _bonfireRepository?.updateBonfireRating(event.id, likes, dislikes),
        _bonfireRepository?.updateBonfireExpirationDate(event.id, 1, 1),
      ]);
    } catch (error) {
      yield BonfireErrorState(error: error);
    }
  }

  Stream<BonfireState> _mapOnFollowClickedToState(
      EVTOnFollowClicked event) async* {
    yield STEAddingFollowing();
    try {
      final int followingCount = _localStorageRepository
              ?.getUserSessionData(Constants.sessionFollowing)
              ?.length as int ??
          0;

      if (followingCount >= 100) {
        yield BonfireErrorState(
            error: FollowingLimitReachedException(event.errorMessage));
      } else {
        await _userDataRepository?.followUser(event.followingUid);

        final List<String> following = _localStorageRepository
            ?.getUserSessionData(Constants.sessionFollowing) as List<String>;
        yield STEFollowingAdded(
            isFollowing: following?.contains(event.followingUid));
      }
    } catch (error) {
      yield BonfireErrorState(error: error);
    }
  }

  Stream<BonfireState> _mapOnUnfollowClickedToState(
      EVTOnUnfollowClicked event) async* {
    yield STERemovingFollowing();
    try {
      await _userDataRepository?.unfollowUser(event.unfollowingUid);

      final List<String> following = _localStorageRepository
          ?.getUserSessionData(Constants.sessionFollowing) as List<String>;
      yield STEFollowingRemoved(
          isFollowing: following?.contains(event.unfollowingUid));
    } catch (error) {
      yield BonfireErrorState(error: error);
    }
  }

  Stream<BonfireState> _mapOnFetchBonfireUserDetailsToState(
      EVTOnFetchBonfireUserDetails event) async* {
    yield STEFetchingBonfireUserDetails();
    try {
      final BonfireUserDetails details = await _userDataRepository
              ?.getUserByUid(event.authorUid, UserDataType.BONFIRE_USER_DETAILS)
          as BonfireUserDetails;
      yield STEFetchedBonfireUserDetails(userDetails: details);
    } catch (error) {
      yield BonfireErrorState(error: error);
    }
  }
}
