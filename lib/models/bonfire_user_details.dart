import 'package:cloud_firestore/cloud_firestore.dart';

class BonfireUserDetails {
  final List<String> trophies;
  final int experience, level;
  final String photoUrl, name, uid, username;

  BonfireUserDetails({
    this.experience,
    this.level,
    this.photoUrl,
    this.name,
    this.trophies,
    this.uid,
    this.username,
  });

  factory BonfireUserDetails.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return BonfireUserDetails(
      experience: data['experience'] as int,
      level: data['level'] as int,
      photoUrl: data['photoUrl'] as String,
      name: data['name'] as String,
      trophies: data['trophies'] as List<String>,
      uid: data['uid'] as String,
      username: data['username'] as String,
    );
  }
}
