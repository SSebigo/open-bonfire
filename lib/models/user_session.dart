import 'package:cloud_firestore/cloud_firestore.dart';

class UserSession {
  bool isAnonymous;
  int bonfireCount,
      createdAt,
      experience,
      dayFileBonfireCount,
      dayImageBonfireCount,
      dayTextBonfireCount,
      dayVideoBonfireCount,
      fileBonfireCount,
      imageBonfireCount,
      level,
      nextLevelExperience,
      textBonfireCount,
      updatedAt,
      videoBonfireCount;
  List<String> following, trophies, missingTrophies;
  String country,
      email,
      name,
      password,
      photoUrl,
      skinUniqueName,
      uid,
      username;
  Map<String, dynamic> dailyQuest, penalty;

  UserSession({
    this.bonfireCount,
    this.country,
    this.createdAt,
    this.dailyQuest,
    this.dayFileBonfireCount,
    this.dayImageBonfireCount,
    this.dayTextBonfireCount,
    this.dayVideoBonfireCount,
    this.email,
    this.experience,
    this.fileBonfireCount,
    this.following,
    this.imageBonfireCount,
    this.isAnonymous,
    this.level,
    this.missingTrophies,
    this.name,
    this.nextLevelExperience,
    this.password,
    this.penalty,
    this.photoUrl,
    this.skinUniqueName,
    this.textBonfireCount,
    this.trophies,
    this.uid,
    this.updatedAt,
    this.username,
    this.videoBonfireCount,
  });

  factory UserSession.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return UserSession(
      bonfireCount: data['bonfireCount'] as int,
      country: data['country'] as String,
      createdAt: data['createdAt'] as int,
      dailyQuest: data['dailyQuest']?.cast<String, dynamic>() as Map<String, dynamic>,
      dayFileBonfireCount: data['dayFileBonfireCount'] as int,
      dayImageBonfireCount: data['dayImageBonfireCount'] as int,
      dayTextBonfireCount: data['dayTextBonfireCount'] as int,
      dayVideoBonfireCount: data['dayVideoBonfireCount'] as int,
      email: data['email'] as String,
      experience: data['experience'] as int,
      fileBonfireCount: data['fileBonfireCount'] as int,
      following: data['following']?.cast<String>() as List<String>,
      imageBonfireCount: data['imageBonfireCount'] as int,
      level: data['level'] as int,
      missingTrophies: data['missingTrophies']?.cast<String>() as List<String>,
      name: data['name'] as String,
      nextLevelExperience: data['nextLevelExperience'] as int,
      penalty: data['penalty']?.cast<String, dynamic>() as Map<String, dynamic>,
      photoUrl: data['photoUrl'] as String,
      skinUniqueName: data['skinUniqueName'] as String,
      textBonfireCount: data['textBonfireCount'] as int,
      trophies: data['trophies']?.cast<String>() as List<String>,
      uid: data['uid'] as String,
      updatedAt: data['updatedAt'] as int,
      username: data['username'] as String,
      videoBonfireCount: data['videoBonfireCount'] as int,
    );
  }

  factory UserSession.fromMap(Map data) {
    return UserSession(
      bonfireCount: data['bonfireCount'] as int,
      country: data['country'] as String,
      createdAt: data['createdAt'] as int,
      dailyQuest: data['dailyQuest']?.cast<String, dynamic>() as Map<String, dynamic>,
      dayFileBonfireCount: data['dayFileBonfireCount'] as int,
      dayImageBonfireCount: data['dayImageBonfireCount'] as int,
      dayTextBonfireCount: data['dayTextBonfireCount'] as int,
      dayVideoBonfireCount: data['dayVideoBonfireCount'] as int,
      email: data['email'] as String,
      experience: data['experience'] as int,
      fileBonfireCount: data['fileBonfireCount'] as int,
      following: data['following']?.cast<String>() as List<String>,
      imageBonfireCount: data['imageBonfireCount'] as int,
      isAnonymous: data['isAnonymous'] as bool,
      level: data['level'] as int,
      missingTrophies: data['missingTrophies']?.cast<String>() as List<String>,
      name: data['name'] as String,
      nextLevelExperience: data['nextLevelExperience'] as int,
      password: data['password'] as String,
      penalty: data['penalty']?.cast<String, dynamic>() as Map<String, dynamic>,
      photoUrl: data['photoUrl'] as String,
      skinUniqueName: data['skinUniqueName'] as String,
      textBonfireCount: data['textBonfireCount'] as int,
      trophies: data['trophies']?.cast<String>() as List<String>,
      uid: data['uid'] as String,
      updatedAt: data['updatedAt'] as int,
      username: data['username'] as String,
      videoBonfireCount: data['videoBonfireCount'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['bonfireCount'] = bonfireCount;
    map['country'] = country;
    map['createdAt'] = createdAt;
    map['dailyQuest'] = dailyQuest;
    map['dayFileBonfireCount'] = dayFileBonfireCount;
    map['dayImageBonfireCount'] = dayImageBonfireCount;
    map['dayTextBonfireCount'] = dayTextBonfireCount;
    map['dayVideoBonfireCount'] = dayVideoBonfireCount;
    map['email'] = email;
    map['experience'] = experience;
    map['fileBonfireCount'] = fileBonfireCount;
    map['following'] = following;
    map['imageBonfireCount'] = imageBonfireCount;
    map['isAnonymous'] = isAnonymous;
    map['level'] = level;
    map['missingTrophies'] = missingTrophies;
    map['name'] = name;
    map['nextLevelExperience'] = nextLevelExperience;
    map['password'] = password;
    map['penalty'] = penalty;
    map['photoUrl'] = photoUrl;
    map['skinUniqueName'] = skinUniqueName;
    map['textBonfireCount'] = textBonfireCount;
    map['trophies'] = trophies;
    map['uid'] = uid;
    map['updatedAt'] = updatedAt;
    map['username'] = username;
    map['videoBonfireCount'] = videoBonfireCount;
    return map;
  }

  @override
  String toString() {
    return '''
      bonfireCount: $bonfireCount,
      country: $country,
      createdAt: $createdAt,
      dailyQuest: $dailyQuest,
      dayFileBonfireCount: $dayFileBonfireCount,
      dayImageBonfireCount: $dayImageBonfireCount,
      dayTextBonfireCount: $dayTextBonfireCount,
      dayVideoBonfireCount: $dayVideoBonfireCount,
      email: $email,
      experience: $experience,
      fileBonfireCount: $fileBonfireCount,
      following: $following,
      imageBonfireCount: $imageBonfireCount,
      isAnonymous: $isAnonymous,
      level: $level,
      missingTrophies: $missingTrophies,
      name: $name,
      nextLevelExperience: $nextLevelExperience,
      password: $password,
      penalty: $penalty,
      photoUrl: $photoUrl,
      skinUniqueName: $skinUniqueName,
      textBonfireCount: $textBonfireCount,
      trophies: $trophies,
      uid: $uid,
      updatedAt: $updatedAt,
      username: $username,
      videoBonfireCount: $videoBonfireCount,
    ''';
  }
}
