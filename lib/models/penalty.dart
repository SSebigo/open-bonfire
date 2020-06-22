import 'package:cloud_firestore/cloud_firestore.dart';

class Penalty {
  Map<String, String> description, title;
  String id, uniqueName;

  Penalty({
    this.description,
    this.id,
    this.title,
    this.uniqueName,
  });

  factory Penalty.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return Penalty(
      description: data['description']?.cast<String, String>() as Map<String, String>,
      id: data['id'] as String,
      title: data['title']?.cast<String, String>() as Map<String, String>,
      uniqueName: data['uniqueName'] as String,
    );
  }

  factory Penalty.fromMap(Map data) {
    return Penalty(
      description: data['description']?.cast<String, String>() as Map<String, String>,
      id: data['id'] as String,
      title: data['title']?.cast<String, String>() as Map<String, String>,
      uniqueName: data['uniqueName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['description'] = description;
    map['id'] = id;
    map['title'] = title;
    map['uniqueName'] = uniqueName;
    return map;
  }

  @override
  String toString() {
    return '''
      description: $description,
      id: $id,
      title: $title,
      uniqueName: $uniqueName,
    ''';
  }
}
