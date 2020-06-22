import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'trophy.g.dart';

@HiveType(typeId: 0)
class Trophy {
  @HiveField(0)
  final Map<String, String> title;

  @HiveField(1)
  final Map<String, String> description;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final String iconUrl;

  @HiveField(4)
  final String uniqueName;

  Trophy({
    this.description,
    this.iconUrl,
    this.id,
    this.title,
    this.uniqueName,
  });

  factory Trophy.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return Trophy(
      description: data['description']?.cast<String, String>() as Map<String, String>,
      iconUrl: data['iconUrl'] as String,
      id: data['id'] as String,
      title: data['title']?.cast<String, String>() as Map<String, String>,
      uniqueName: data['uniqueName'] as String,
    );
  }

  factory Trophy.fromMap(Map data) {
    return Trophy(
      description: data['description']?.cast<String, String>() as Map<String, String>,
      iconUrl: data['iconUrl'] as String,
      id: data['id'] as String,
      title: data['title']?.cast<String, String>() as Map<String, String>,
      uniqueName: data['uniqueName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['description'] = description;
    map['iconUrl'] = iconUrl;
    map['id'] = id;
    map['title'] = title;
    map['uniqueName'] = uniqueName;
    return map;
  }

  @override
  String toString() {
    return '''
      description: $description,
      iconUrl: $iconUrl
      id: $id,
      title: $title,
      uniqueName: $uniqueName,
    ''';
  }
}
