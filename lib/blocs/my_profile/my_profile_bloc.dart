import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/models/follow.dart';
import 'package:bonfire/repositories/bonfire_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/online_storage_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/paths.dart';
import './bloc.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final OnlineStorageRepository _onlineStorageRepository = OnlineStorageRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();

  StreamSubscription<List<Bonfire>> _bonfireSubscription;
  final BonfireRepository _bonfireRepository = BonfireRepository();

  MyProfileBloc() : super(InitialMyProfileState());

  @override
  Stream<MyProfileState> mapEventToState(MyProfileEvent event) async* {
    if (event is EVTOnGoBackClicked) {
      yield STEGoingBack();
      yield STEWentBack();
    }
    if (event is EVTOnProfilePictureClicked) {
      yield STEUpdatingProfilePicture();
      try {
        final String profilePictureUrl =
            await _onlineStorageRepository?.uploadFile(event.file, Paths.profilePicturePath);
        await _userDataRepository?.updateProfilePicture(profilePictureUrl);
        yield STEProfilePictureUpdated(profilePictureUrl: profilePictureUrl);
      } catch (error) {
        yield MyProfileErrorState(error: error);
      }
    }
    if (event is EVTOnFetchUserBonfires) {
      yield* _mapOnFetchUserBonfiresEventToState(event);
    }
    if (event is EVTOnReceivedUserBonfires) {
      yield* _mapOnReceivedUserBonfiresEventToState(event);
    }
    if (event is EVTOnUnfollowClicked) {
      yield* _mapOnUnfollowClickedToState(event);
    }
    if (event is EVTOnFetchFollowingDetails) {
      yield* _mapOnFetchFollowingDetailsToState(event);
    }
  }

  Stream<MyProfileState> _mapOnFetchUserBonfiresEventToState(EVTOnFetchUserBonfires event) async* {
    yield STEFetchingUserBonfires();
    try {
      final String uid = _localStorageRepository?.getUserSessionData(Constants.sessionUid) as String;
      _bonfireSubscription?.cancel();
      _bonfireSubscription = _bonfireRepository
          .getUserBonfires(uid)
          .listen((bonfires) => add(EVTOnReceivedUserBonfires(bonfires: bonfires)));
    } catch (error) {
      yield MyProfileErrorState(error: error);
    }
  }

  Stream<MyProfileState> _mapOnReceivedUserBonfiresEventToState(EVTOnReceivedUserBonfires event) async* {
    try {
      final int now = DateTime.now().millisecondsSinceEpoch;
      event.bonfires.forEach((bonfire) {
        if (bonfire.expiresAt <= now) {
          bonfire.expired = true;
          _bonfireRepository?.updateBonfireExpiration(bonfire.id);
        }
      });
      event.bonfires.removeWhere((bonfire) => bonfire.expired);
      yield STEFetchedUserBonfires(bonfires: event.bonfires);
    } catch (error) {
      yield MyProfileErrorState(error: error);
    }
  }

  Stream<MyProfileState> _mapOnUnfollowClickedToState(EVTOnUnfollowClicked event) async* {
    yield STERemovingFollowing();
    try {
      await _userDataRepository?.unfollowUser(event.unfollowingUid);
      final List<Follow> following = await _userDataRepository?.getFollowing();
      yield STEFollowingRemoved(following: following);
    } catch (error) {
      yield MyProfileErrorState(error: error);
    }
  }

  Stream<MyProfileState> _mapOnFetchFollowingDetailsToState(EVTOnFetchFollowingDetails event) async* {
    yield STEFetchingFollowingDetails();
    try {
      final List<Follow> following = await _userDataRepository?.getFollowing();
      yield STEFetchedFollowingDetails(following: following);
    } catch (error) {
      yield MyProfileErrorState(error: error);
    }
  }
}
