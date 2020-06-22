import 'package:bonfire/models/bonfire_user_details.dart';
import 'package:bonfire/models/follow.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/models/user_data_type.dart';
import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/services/user_data/base_user_data_service.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/exceptions.dart';
import 'package:bonfire/utils/methods.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class FirebaseUserDataService extends BaseUserDataService {
  final Logger logger = Logger();
  final Firestore _firestore = Firestore.instance;
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  static final FirebaseUserDataService _singleton =
      FirebaseUserDataService._internal();

  FirebaseUserDataService._internal();

  factory FirebaseUserDataService() => _singleton;

  @override
  Future<UserSession> saveDetailsFromAuth(FirebaseUser user) async {
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(user.uid);
    final bool userExists = !await ref.snapshots().isEmpty;
    final data = {
      'email': user.email,
      'name': user.displayName,
      'uid': user.uid,
    };
    if (!userExists && user.photoUrl != null) {
      data['photoUrl'] = user.photoUrl;
    }

    await ref.setData(data, merge: true);

    // get updated document reference
    final DocumentSnapshot currentDocument = await ref.get();

    await _localStorageRepository?.setUserSession(UserSession(
      email: user.email,
      isAnonymous: false,
      name: user.displayName,
      photoUrl: user.photoUrl,
      uid: user.uid,
    ));

    return UserSession.fromFirestore(currentDocument);
  }

  @override
  Future<void> checkUsernameAvailability(String username) async {
    final DocumentSnapshot documentSnapshot = await _firestore
        .collection(Paths.usernameUidMapPath)
        .document(username)
        .get();
    if (documentSnapshot != null && documentSnapshot.exists) {
      throw UsernameAlreadyExistsException(
          'This username is already in use by another account');
    }
  }

  @override
  Future<UserSession> saveProfileDetails({
    String name,
    String profilePictureUrl,
    String username,
  }) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;

    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final String country =
        (await Geolocator().placemarkFromPosition(position))[0].country;

    final DocumentReference mapReference =
        _firestore.collection(Paths.usernameUidMapPath).document(username);

    // map the uid to the username
    await mapReference.setData({'uid': uid}, merge: true);

    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);
    final data = {
      'bonfireCount': 0,
      'country': country,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'dailyQuest': null,
      'experience': 0,
      'dayFileBonfireCount': 0,
      'dayImageBonfireCount': 0,
      'dayTextBonfireCount': 0,
      'dayVideoBonfireCount': 0,
      'fileBonfireCount': 0,
      'following': null,
      'imageBonfireCount': 0,
      'level': 1,
      'name': name,
      'nextLevelExperience': nextLevel(1),
      'penalty': null,
      'photoUrl': profilePictureUrl,
      'skinUniqueName': 'default',
      'textBonfireCount': 0,
      'trophies': null,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'username': username,
      'videoBonfireCount': 0,
    };

    await ref.setData(data, merge: true);

    final DocumentSnapshot currentDocument = await ref.get();

    final String email = _localStorageRepository
        ?.getUserSessionData(Constants.sessionEmail) as String;
    final bool isAnonymous = _localStorageRepository
        ?.getUserSessionData(Constants.sessionIsAnonymous) as bool;
    final String password = _localStorageRepository
        ?.getUserSessionData(Constants.sessionPassword) as String;

    await _localStorageRepository?.setUserSession(UserSession(
      bonfireCount: 0,
      country: country,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      dailyQuest: null,
      email: email,
      experience: 0,
      dayFileBonfireCount: 0,
      dayImageBonfireCount: 0,
      dayTextBonfireCount: 0,
      dayVideoBonfireCount: 0,
      fileBonfireCount: 0,
      following: null,
      imageBonfireCount: 0,
      isAnonymous: isAnonymous,
      level: 1,
      name: name,
      nextLevelExperience: nextLevel(1),
      password: password,
      penalty: null,
      photoUrl: profilePictureUrl,
      skinUniqueName: 'default',
      textBonfireCount: 0,
      trophies: null,
      uid: uid,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      username: username,
      videoBonfireCount: 0,
    ));

    return UserSession.fromFirestore(currentDocument);
  }

  @override
  Future<bool> isProfileComplete() async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final DocumentSnapshot currentDocument = await ref.get();

    final bool isProfileComplete = currentDocument != null &&
        currentDocument.exists &&
        currentDocument.data.containsKey('username') &&
        currentDocument.data.containsKey('name');

    if (isProfileComplete) {
      await _localStorageRepository?.setUserSession(UserSession(
        bonfireCount: currentDocument.data['bonfireCount'] as int ?? 0,
        country: currentDocument.data['country'] as String,
        createdAt: currentDocument.data['createdAt'] as int,
        dailyQuest: currentDocument.data['dailyQuest']?.cast<String, dynamic>() as Map<String, dynamic>,
        dayFileBonfireCount:
            currentDocument.data['dayFileBonfireCount'] as int ?? 0,
        dayImageBonfireCount:
            currentDocument.data['dayImageBonfireCount'] as int ?? 0,
        dayTextBonfireCount:
            currentDocument.data['dayTextBonfireCount'] as int ?? 0,
        dayVideoBonfireCount:
            currentDocument.data['dayVideoBonfireCount'] as int ?? 0,
        email: currentDocument.data['email'] as String,
        experience: currentDocument.data['experience'] as int,
        fileBonfireCount: currentDocument.data['fileBonfireCount'] as int ?? 0,
        following: currentDocument.data['following'] as List<String>,
        imageBonfireCount:
            currentDocument.data['imageBonfireCount'] as int ?? 0,
        isAnonymous: false,
        level: (currentDocument.data['level'] == 0
                ? 1
                : currentDocument.data['level'] as int) ??
            1,
        name: currentDocument.data['name'] as String,
        nextLevelExperience: nextLevel((currentDocument.data['level'] == 0
                ? 1
                : currentDocument.data['level'] as int) ??
            1),
        penalty: currentDocument.data['penalty']?.cast<String, dynamic>() as Map<String, dynamic>,
        photoUrl: currentDocument.data['photoUrl'] as String,
        textBonfireCount: currentDocument.data['textBonfireCount'] as int ?? 0,
        trophies: currentDocument.data['trophies'] as List<String>,
        skinUniqueName:
            currentDocument.data['skinUniqueName'] as String ?? 'default',
        uid: uid,
        updatedAt: currentDocument.data['updatedAt'] as int,
        username: currentDocument.data['username'] as String,
        videoBonfireCount:
            currentDocument.data['videoBonfireCount'] as int ?? 0,
      ));
    }
    return isProfileComplete;
  }

  @override
  Future<UserSession> getUser(String username) async {
    final String uid = await getUidByUsername(username);
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final DocumentSnapshot snapshot = await ref.get();

    if (snapshot != null && snapshot.exists) {
      return UserSession.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException('No user found for provided uid/username');
    }
  }

  @override
  Future<String> getUidByUsername(String username) async {
    final DocumentReference ref =
        _firestore.collection(Paths.usernameUidMapPath).document(username);
    final DocumentSnapshot documentSnapshot = await ref.get();
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data['uid'] != null) {
      return documentSnapshot.data['uid'] as String;
    } else {
      throw UsernameMappingUndefinedException('User not found');
    }
  }

  @override
  Future<dynamic> getUserByUid(String uid, UserDataType type) async {
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final DocumentSnapshot documentSnapshot = await ref.get();
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data['uid'] != null) {
      switch (type) {
        case UserDataType.BONFIRE_USER_DETAILS:
          return BonfireUserDetails.fromFirestore(documentSnapshot);
          break;
        case UserDataType.FOLLOW:
          return Follow.fromFirestore(documentSnapshot);
          break;
        default:
          return null;
      }
    } else {
      throw UsernameMappingUndefinedException('User not found');
    }
  }

  @override
  Future<void> updateLastModified() async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final int now = DateTime.now().millisecondsSinceEpoch;

    await Future.wait([
      ref.setData({'updatedAt': now}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionUpdatedAt, now),
    ]);
  }

  @override
  Future<void> updateProfilePicture(String profilePictureUrl) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);
    final data = {
      'photoUrl': profilePictureUrl,
    };

    await Future.wait([
      ref.setData(data, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionProfilePictureUrl, profilePictureUrl),
    ]);
  }

  @override
  Future<void> updateName(String name) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({'name': name}, merge: true),
      _localStorageRepository?.setUserSessionData(Constants.sessionName, name),
    ]);
  }

  @override
  Future<void> updateBonfireCount() async {
    int bonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionBonfireCount) as int;
    bonfireCount += 1;

    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({'bonfireCount': bonfireCount}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionBonfireCount, bonfireCount),
    ]);
  }

  @override
  Future<void> followUser(String followingUid) async {
    final String sessionUid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference followerRef =
        _firestore.collection(Paths.usersPath).document(sessionUid);

    final List<String> following = _localStorageRepository
        ?.getUserSessionData(Constants.sessionFollowing) as List<String>;
    final List<String> followingList =
        following == null ? <String>[] : List<String>.from(following);
    followingList.add(followingUid);

    await Future.wait([
      followerRef.setData({
        'following': FieldValue.arrayUnion([followingUid])
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionFollowing, followingList),
    ]);
  }

  @override
  Future<void> unfollowUser(String unfollowingUid) async {
    final String sessionUid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference followerRef =
        _firestore.collection(Paths.usersPath).document(sessionUid);

    final List<String> followingList = List<String>.from(_localStorageRepository
            ?.getUserSessionData(Constants.sessionFollowing) as List<String>) ??
        <String>[];
    followingList.remove(unfollowingUid);

    await Future.wait([
      followerRef.setData({
        'following': FieldValue.arrayRemove([unfollowingUid])
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionFollowing, followingList),
    ]);
  }

  @override
  Future<List<Follow>> getFollowing() async {
    final List<String> following = _localStorageRepository
        ?.getUserSessionData(Constants.sessionFollowing) as List<String>;

    final List<DocumentSnapshot> documentSnapshots = <DocumentSnapshot>[];
    for (final String item in following) {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection(Paths.usersPath).document(item).get();
      documentSnapshots.add(documentSnapshot);
    }

    final List<Follow> followingList = <Follow>[];
    documentSnapshots.forEach((doc) {
      followingList.add(Follow.fromFirestore(doc));
    });
    return followingList;
  }

  @override
  Future<void> updateExperience(int experience) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({
        'experience': experience,
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionExperience, experience),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionUpdateUserExperience, null),
    ]);

    final int currentExperience = _localStorageRepository
        ?.getUserSessionData(Constants.sessionExperience) as int;
    final int nextLevelExperience = _localStorageRepository
        ?.getUserSessionData(Constants.sessionNextLevelExperience) as int;

    if (currentExperience >= nextLevelExperience) {
      await _localStorageRepository?.setUserSessionData(
          Constants.sessionUpdateUserLevel, true);
    }
  }

  @override
  Future<void> updateLevel(int level) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({
        'level': level,
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionLevel, level),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionUpdateUserLevel, null),
    ]);
  }

  @override
  Future<void> updateNextLevelExperience(int level) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final int nextLevelExperience = nextLevel(level);

    await Future.wait([
      ref.setData({
        'nextLevelExperience': nextLevelExperience,
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionNextLevelExperience, nextLevelExperience),
    ]);
  }

  @override
  Future<void> updateDailyQuest(
    int bonfireToLit,
    bool completed,
    String dailyQuestId,
    int deadline,
  ) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final Map<String, dynamic> data = {
      'bonfireToLit': bonfireToLit,
      'completed': completed,
      'deadline': deadline,
      'id': dailyQuestId,
    };

    await Future.wait([
      ref.setData({'dailyQuest': data}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDailyQuest, data),
    ]);
  }

  @override
  Future<void> updateDailyQuestStatus(bool status) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final Map<String, dynamic> dailyQuest =
        _localStorageRepository?.getUserSessionData(Constants.sessionDailyQuest)
            as Map<String, dynamic>;

    await Future.wait([
      ref.setData({
        'dailyQuest': {'completed': status}
      }, merge: true),
      _localStorageRepository?.setUserSessionData(Constants.sessionDailyQuest, {
        'completed': status,
        'deadline': dailyQuest['deadline'],
        'id': dailyQuest['id'],
      }),
    ]);
  }

  @override
  Future<void> updatePenalty(
    int deadline,
    String penaltyId,
  ) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final Map<String, dynamic> data = {
      'id': penaltyId,
      'deadline': deadline,
    };

    await Future.wait([
      ref.setData({'penalty': data}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionPenalty, data),
    ]);
  }

  @override
  Future<void> updateFileBonfireCount() async {
    int dayFileBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayFileBonfireCount) as int;
    int fileBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionFileBonfireCount) as int;

    dayFileBonfireCount += 1;
    fileBonfireCount += 1;

    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({
        'dayFileBonfireCount': dayFileBonfireCount,
        'fileBonfireCount': fileBonfireCount
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayFileBonfireCount, dayFileBonfireCount),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionFileBonfireCount, fileBonfireCount),
    ]);
  }

  @override
  Future<void> updateImageBonfireCount() async {
    int dayImageBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayImageBonfireCount) as int;
    int imageBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionImageBonfireCount) as int;

    dayImageBonfireCount += 1;
    imageBonfireCount += 1;

    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({
        'dayImageBonfireCount': dayImageBonfireCount,
        'imageBonfireCount': imageBonfireCount
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayImageBonfireCount, dayImageBonfireCount),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionImageBonfireCount, imageBonfireCount),
    ]);
  }

  @override
  Future<void> updateTextBonfireCount() async {
    int dayTextBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayTextBonfireCount) as int;
    int textBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionTextBonfireCount) as int;

    dayTextBonfireCount += 1;
    textBonfireCount += 1;

    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({
        'dayTextBonfireCount': dayTextBonfireCount,
        'textBonfireCount': textBonfireCount
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayTextBonfireCount, dayTextBonfireCount),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionTextBonfireCount, textBonfireCount),
    ]);
  }

  @override
  Future<void> updateVideoBonfireCount() async {
    int dayVideoBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionDayVideoBonfireCount) as int;
    int videoBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionVideoBonfireCount) as int;

    dayVideoBonfireCount += 1;
    videoBonfireCount += 1;

    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({
        'dayVideoBonfireCount': dayVideoBonfireCount,
        'videoBonfireCount': videoBonfireCount
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayVideoBonfireCount, dayVideoBonfireCount),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionVideoBonfireCount, videoBonfireCount),
    ]);
  }

  @override
  Future<void> updateSkinUniqueName(String skinUniqueName) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({'skinUniqueName': skinUniqueName}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionSkinUniqueName, skinUniqueName),
    ]);
  }

  @override
  Future<void> updateTrophies(String trophyId) async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final List<String> trophies = List.from(_localStorageRepository
            ?.getUserSessionData(Constants.sessionTrophies) as List<String> ??
        <String>[]);
    trophies.add(trophyId);

    await Future.wait([
      ref.setData({
        'trophies': FieldValue.arrayUnion([trophyId])
      }, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionTrophies, trophies),
    ]);
  }

  @override
  Future<void> updateMissingTrophies(List<Trophy> trophies) async {
    await _localStorageRepository?.setUserSessionData(
        Constants.sessionMissingTrophies, trophies);
  }

  @override
  Future<void> nullifyDailyQuest() async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({'dailyQuest': null}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDailyQuest, null),
    ]);
  }

  @override
  Future<void> nullifyPenalty() async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    await Future.wait([
      ref.setData({'penalty': null}, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionPenalty, null),
    ]);
  }

  @override
  Future<void> zerofyAllBonfireTypesCount() async {
    final String uid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;
    final DocumentReference ref =
        _firestore.collection(Paths.usersPath).document(uid);

    final Map<String, dynamic> data = {
      'dayFileBonfireCount': 0,
      'dayImageBonfireCount': 0,
      'dayTextBonfireCount': 0,
      'dayVideoBonfireCount': 0,
    };

    await Future.wait([
      ref.setData(data, merge: true),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayFileBonfireCount, 0),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayImageBonfireCount, 0),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayTextBonfireCount, 0),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionDayVideoBonfireCount, 0),
    ]);
  }

  @override
  void dispose() {}
}
