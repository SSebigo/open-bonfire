import 'package:bonfire/models/follow.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/models/user_data_type.dart';
import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/services/base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseUserDataService extends BaseService {
  Future<UserSession> saveDetailsFromAuth(FirebaseUser user);
  Future<void> checkUsernameAvailability(String username);
  Future<UserSession> saveProfileDetails({
    String name,
    String profilePictureUrl,
    String username,
  });
  Future<bool> isProfileComplete();
  Future<UserSession> getUser(String username);
  Future<String> getUidByUsername(String username);
  Future<dynamic> getUserByUid(String uid, UserDataType type);

  Future<void> updateLastModified();
  Future<void> updateProfilePicture(String profilePictureUrl);
  Future<void> updateName(String name);
  Future<void> updateBonfireCount();
  Future<void> followUser(String followingId);
  Future<void> unfollowUser(String unfollowingId);
  Future<List<Follow>> getFollowing();
  Future<void> updateExperience(int experience);
  Future<void> updateLevel(int level);
  Future<void> updateNextLevelExperience(int level);
  Future<void> updateDailyQuest(
    int bonfireToLit,
    bool completed,
    String dailyQuestId,
    int deadline,
  );
  Future<void> updateDailyQuestStatus(bool status);
  Future<void> updatePenalty(
    int deadline,
    String penaltyId,
  );
  Future<void> updateFileBonfireCount();
  Future<void> updateImageBonfireCount();
  Future<void> updateTextBonfireCount();
  Future<void> updateVideoBonfireCount();
  Future<void> updateSkinUniqueName(String skinUniqueName);
  Future<void> updateTrophies(String trophyId);
  Future<void> updateMissingTrophies(List<Trophy> trophies);

  Future<void> nullifyDailyQuest();
  Future<void> nullifyPenalty();
  Future<void> zerofyAllBonfireTypesCount();
}
