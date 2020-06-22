import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

abstract class Bonfire {
  bool deleted, expired;
  int createdAt, expiresAt;
  List<String> dislikes, likes, viewedBy, visibleBy;
  Position position;
  String authorUid, id;

  Bonfire({
    this.createdAt,
    this.deleted,
    this.dislikes,
    this.expired,
    this.expiresAt,
    this.id,
    this.likes,
    this.position,
    this.authorUid,
    this.viewedBy,
    this.visibleBy,
  });

  factory Bonfire.fromFireStore(DocumentSnapshot document) {
    final int type = document.data['type'] as int;
    Bonfire bonfire;
    switch (type) {
      case 0:
        bonfire = TextBonfire.fromFirestore(document);
        break;
      case 1:
        bonfire = ImageBonfire.fromFirestore(document);
        break;
      case 2:
        bonfire = VideoBonfire.fromFirestore(document);
        break;
      case 3:
        bonfire = FileBonfire.fromFirestore(document);
        break;
    }
    return bonfire;
  }

  Map<String, dynamic> toMap();
}

class TextBonfire extends Bonfire {
  String text;

  TextBonfire({
    this.text,
    createdAt,
    deleted,
    dislikes,
    expired,
    expiresAt,
    id,
    likes,
    position,
    authorUid,
    viewedBy,
    visibleBy,
  }) : super(
          createdAt: createdAt as int,
          deleted: deleted as bool,
          dislikes: dislikes as List<String>,
          expired: expired as bool,
          expiresAt: expiresAt as int,
          id: id as String,
          likes: likes as List<String>,
          position: position as Position,
          authorUid: authorUid as String,
          viewedBy: viewedBy as List<String>,
          visibleBy: visibleBy as List<String>,
        );

  factory TextBonfire.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    final GeoPoint geoPoint = data['position']['geopoint'] as GeoPoint;
    return TextBonfire(
      createdAt: data['createdAt'],
      deleted: data['deleted'],
      dislikes: data['dislikes'],
      expired: data['expired'],
      expiresAt: data['expiresAt'],
      id: data['id'],
      likes: data['likes'],
      position: Position(
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      ),
      text: data['text'] as String,
      authorUid: data['authorUid'],
      viewedBy: data['viewedBy'],
      visibleBy: data['visibleBy'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['deleted'] = deleted;
    map['dislikes'] = dislikes;
    map['expired'] = expired;
    map['expiresAt'] = expiresAt;
    map['id'] = id;
    map['likes'] = likes;
    map['position'] = Geoflutterfire()
        .point(latitude: position.latitude, longitude: position.longitude)
        .data;
    map['text'] = text;
    map['type'] = 0;
    map['authorUid'] = authorUid;
    map['viewedBy'] = viewedBy;
    map['visibleBy'] = visibleBy;
    return map;
  }
}

class ImageBonfire extends Bonfire {
  String imageUrl;
  String description;

  ImageBonfire({
    this.imageUrl,
    this.description,
    createdAt,
    deleted,
    dislikes,
    expired,
    expiresAt,
    id,
    likes,
    position,
    authorUid,
    viewedBy,
    visibleBy,
  }) : super(
          createdAt: createdAt as int,
          deleted: deleted as bool,
          dislikes: dislikes as List<String>,
          expired: expired as bool,
          expiresAt: expiresAt as int,
          id: id as String,
          likes: likes as List<String>,
          position: position as Position,
          authorUid: authorUid as String,
          viewedBy: viewedBy as List<String>,
          visibleBy: visibleBy as List<String>,
        );

  factory ImageBonfire.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    final GeoPoint geoPoint = data['position']['geopoint'] as GeoPoint;
    return ImageBonfire(
      createdAt: data['createdAt'],
      deleted: data['deletes'],
      description: data['description'] as String,
      dislikes: data['dislikes'],
      expired: data['expired'],
      expiresAt: data['expiresAt'],
      id: data['id'],
      imageUrl: data['imageUrl'] as String,
      likes: data['likes'],
      position: Position(
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      ),
      authorUid: data['authorUid'],
      viewedBy: data['viewedBy'],
      visibleBy: data['visibleBy'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['deleted'] = deleted;
    map['description'] = description;
    map['dislikes'] = dislikes;
    map['expired'] = expired;
    map['expiresAt'] = expiresAt;
    map['id'] = id;
    map['imageUrl'] = imageUrl;
    map['likes'] = likes;
    map['position'] = Geoflutterfire()
        .point(latitude: position.latitude, longitude: position.longitude)
        .data;
    map['type'] = 1;
    map['authorUid'] = authorUid;
    map['viewedBy'] = viewedBy;
    map['visibleBy'] = visibleBy;
    return map;
  }
}

class VideoBonfire extends Bonfire {
  String videoUrl;
  String description;

  VideoBonfire({
    this.videoUrl,
    this.description,
    createdAt,
    deleted,
    dislikes,
    expired,
    expiresAt,
    id,
    likes,
    position,
    authorUid,
    viewedBy,
    visibleBy,
  }) : super(
          createdAt: createdAt as int,
          deleted: deleted as bool,
          dislikes: dislikes as List<String>,
          expired: expired as bool,
          expiresAt: expiresAt as int,
          id: id as String,
          likes: likes as List<String>,
          position: position as Position,
          authorUid: authorUid as String,
          viewedBy: viewedBy as List<String>,
          visibleBy: visibleBy as List<String>,
        );

  factory VideoBonfire.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    final GeoPoint geoPoint = data['position']['geopoint'] as GeoPoint;
    return VideoBonfire(
      createdAt: data['createdAt'],
      deleted: data['deletes'],
      description: data['description'] as String,
      dislikes: data['dislikes'],
      expired: data['expired'],
      expiresAt: data['expiresAt'],
      id: data['id'],
      likes: data['likes'],
      position: Position(
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      ),
      authorUid: data['authorUid'],
      videoUrl: data['videoUrl'] as String,
      viewedBy: data['viewedBy'],
      visibleBy: data['visibleBy'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['deleted'] = deleted;
    map['description'] = description;
    map['dislikes'] = dislikes;
    map['expired'] = expired;
    map['expiresAt'] = expiresAt;
    map['id'] = id;
    map['likes'] = likes;
    map['position'] = Geoflutterfire()
        .point(latitude: position.latitude, longitude: position.longitude)
        .data;
    map['type'] = 2;
    map['authorUid'] = authorUid;
    map['videoUrl'] = videoUrl;
    map['viewedBy'] = viewedBy;
    map['visibleBy'] = visibleBy;
    return map;
  }
}

class FileBonfire extends Bonfire {
  String fileUrl;
  String fileName;
  String description;

  FileBonfire({
    this.fileUrl,
    this.fileName,
    this.description,
    createdAt,
    deleted,
    dislikes,
    expired,
    expiresAt,
    id,
    likes,
    position,
    authorUid,
    viewedBy,
    visibleBy,
  }) : super(
          createdAt: createdAt as int,
          deleted: deleted as bool,
          dislikes: dislikes as List<String>,
          expired: expired as bool,
          expiresAt: expiresAt as int,
          id: id as String,
          likes: likes as List<String>,
          position: position as Position,
          authorUid: authorUid as String,
          viewedBy: viewedBy as List<String>,
          visibleBy: visibleBy as List<String>,
        );

  factory FileBonfire.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    final GeoPoint geoPoint = data['position']['geopoint'] as GeoPoint;
    return FileBonfire(
      createdAt: data['createdAt'],
      deleted: data['deletes'],
      description: data['description'] as String,
      dislikes: data['dislikes'],
      expired: data['expired'],
      expiresAt: data['expiresAt'],
      fileName: data['fileName'] as String,
      fileUrl: data['fileUrl'] as String,
      id: data['id'],
      likes: data['likes'],
      position: Position(
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      ),
      authorUid: data['authorUid'],
      viewedBy: data['viewedBy'],
      visibleBy: data['visibleBy'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['deleted'] = deleted;
    map['description'] = description;
    map['dislikes'] = dislikes;
    map['expired'] = expired;
    map['expiresAt'] = expiresAt;
    map['fileName'] = fileName;
    map['fileUrl'] = fileUrl;
    map['id'] = id;
    map['likes'] = likes;
    map['position'] = Geoflutterfire()
        .point(latitude: position.latitude, longitude: position.longitude)
        .data;
    map['type'] = 3;
    map['authorUid'] = authorUid;
    map['viewedBy'] = viewedBy;
    map['visibleBy'] = visibleBy;
    return map;
  }
}
