import 'package:cloud_firestore/cloud_firestore.dart';

class Follow {
  String name, photoUrl, username, uid;

  Follow({
    this.name,
    this.photoUrl,
    this.username,
    this.uid,
  });

  factory Follow.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return Follow(
      name: data['name'] as String,
      photoUrl: data['photoUrl'] as String,
      username: data['username'] as String,
      uid: data['uid'] as String,
    );
  }

  factory Follow.fromMap(Map data) {
    return Follow(
      name: data['name'] as String,
      photoUrl: data['photoUrl'] as String,
      username: data['username'] as String,
      uid: data['uid'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['name'] = name;
    map['photoUrl'] = photoUrl;
    map['username'] = username;
    map['uid'] = uid;
    return map;
  }

  @override
  String toString() {
    return '''
      name: $name,
      photoUrl: $photoUrl,
      username: $username,
      uid: $uid,
    ''';
  }
}
