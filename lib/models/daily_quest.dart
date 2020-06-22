import 'package:cloud_firestore/cloud_firestore.dart';

class DailyQuest {
  bool progressive;
  int experience, maxLevel, minLevel;
  Map<String, String> description, title;
  String id, uniqueName;

  DailyQuest({
    this.description,
    this.experience,
    this.id,
    this.maxLevel,
    this.minLevel,
    this.progressive,
    this.title,
    this.uniqueName,
  });

  factory DailyQuest.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return DailyQuest(
      description:
          data['description']?.cast<String, String>() as Map<String, String>,
      experience: data['experience'] as int,
      id: data['id'] as String,
      maxLevel: data['maxLevel'] as int,
      minLevel: data['minLevel'] as int,
      progressive: data['progressive'] as bool,
      title: data['title']?.cast<String, String>() as Map<String, String>,
      uniqueName: data['uniqueName'] as String,
    );
  }

  factory DailyQuest.fromMap(Map data) {
    return DailyQuest(
      description:
          data['description']?.cast<String, String>() as Map<String, String>,
      experience: data['experience'] as int,
      id: data['id'] as String,
      maxLevel: data['maxLevel'] as int,
      minLevel: data['minLevel'] as int,
      progressive: data['progressive'] as bool,
      title: data['title']?.cast<String, String>() as Map<String, String>,
      uniqueName: data['uniqueName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['description'] = description;
    map['experience'] = experience;
    map['id'] = id;
    map['maxLevel'] = maxLevel;
    map['minLevel'] = minLevel;
    map['progressive'] = progressive;
    map['title'] = title;
    map['uniqueName'] = uniqueName;
    return map;
  }

  @override
  String toString() {
    return '''
      description: $description,
      experience: $experience,
      id: $id,
      maxLevel: $maxLevel,
      minLevel: $minLevel,
      progressive: $progressive,
      title: $title,
      uniqueName: $uniqueName,
    ''';
  }
}
