import 'package:bonfire/models/follow.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/models/user_data_type.dart';
import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/services/user_data/base_user_data_service.dart';
import 'package:bonfire/services/user_data/firebase_user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataRepository {
  final BaseUserDataService _userDataService = FirebaseUserDataService();

  static final UserDataRepository _singleton = UserDataRepository._internal();

  UserDataRepository._internal();

  factory UserDataRepository() => _singleton;

  Future<UserSession> saveDetailsFromAuth(FirebaseUser user) =>
      _userDataService.saveDetailsFromAuth(user);

  Future<void> checkUsernameAvailability(String username) =>
      _userDataService.checkUsernameAvailability(username);

  Future<UserSession> saveProfileDetails({
    String name,
    String profilePictureUrl,
    String username,
  }) =>
      _userDataService.saveProfileDetails(
        name: name,
        profilePictureUrl: profilePictureUrl,
        username: username,
      );

  Future<void> updateProfilePicture(String profilePictureUrl) =>
      _userDataService.updateProfilePicture(profilePictureUrl);

  Future<bool> isProfileComplete() => _userDataService.isProfileComplete();

  Future<UserSession> getUser(String username) =>
      _userDataService.getUser(username);

  Future<String> getUidByUsername(String username) =>
      _userDataService.getUidByUsername(username);

  Future<dynamic> getUserByUid(String uid, UserDataType type) =>
      _userDataService.getUserByUid(uid, type);

  Future<void> updateLastModified() => _userDataService.updateLastModified();

  Future<void> updateName(String name) => _userDataService.updateName(name);

  Future<void> updateBonfireCount() => _userDataService.updateBonfireCount();

  Future<void> followUser(String followingUid) =>
      _userDataService.followUser(followingUid);

  Future<void> unfollowUser(String unfollowingUid) =>
      _userDataService.unfollowUser(unfollowingUid);

  Future<List<Follow>> getFollowing() => _userDataService.getFollowing();

  Future<void> updateExperience(int experience) =>
      _userDataService.updateExperience(experience);

  Future<void> updateLevel(int level) => _userDataService.updateLevel(level);

  Future<void> updateNextLevelExperience(int level) =>
      _userDataService.updateNextLevelExperience(level);

  Future<void> updateDailyQuest(
    int bonfireToLit,
    bool completed,
    String dailyQuestId,
    int deadline,
  ) =>
      _userDataService.updateDailyQuest(
          bonfireToLit, completed, dailyQuestId, deadline);

  Future<void> updateDailyQuestStatus(bool status) =>
      _userDataService.updateDailyQuestStatus(status);

  Future<void> updatePenalty(
    int deadline,
    String penaltyId,
  ) =>
      _userDataService.updatePenalty(deadline, penaltyId);

  Future<void> updateFileBonfireCount() =>
      _userDataService.updateFileBonfireCount();

  Future<void> updateImageBonfireCount() =>
      _userDataService.updateImageBonfireCount();

  Future<void> updateTextBonfireCount() =>
      _userDataService.updateTextBonfireCount();

  Future<void> updateVideoBonfireCount() =>
      _userDataService.updateVideoBonfireCount();

  Future<void> updateSkinUniqueName(String skinUniqueName) =>
      _userDataService.updateSkinUniqueName(skinUniqueName);

  Future<void> updateTrophies(String trophyId) =>
      _userDataService.updateTrophies(trophyId);

  Future<void> updateMissingTrophies(List<Trophy> trophies) =>
      _userDataService.updateMissingTrophies(trophies);

  Future<void> nullifyDailyQuest() => _userDataService.nullifyDailyQuest();

  Future<void> nullifyPenalty() => _userDataService.nullifyPenalty();

  Future<void> zerofyAllBonfireTypesCount() =>
      _userDataService.zerofyAllBonfireTypesCount();
}
