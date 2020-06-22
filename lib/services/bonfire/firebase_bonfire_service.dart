import 'dart:async';

import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/services/bonfire/base_bonfire_service.dart';
import 'package:bonfire/utils/Paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time/time.dart';

class FirebaseBonfireService extends BaseBonfireService {
  final Firestore _firestore = Firestore.instance;

  static final FirebaseBonfireService _singleton =
      FirebaseBonfireService._internal();

  FirebaseBonfireService._internal();

  factory FirebaseBonfireService() => _singleton;

  @override
  Stream<List<Bonfire>> getBonfires(Position position, double radius) {
    final Geoflutterfire geo = Geoflutterfire();
    final GeoFirePoint center =
        geo.point(latitude: position.latitude, longitude: position.longitude);

    final CollectionReference bonfireCollection =
        _firestore.collection(Paths.bonfiresPath);

    /* NOTE
    ** radius work as follow,
    ** 50.0 = 50km, 10.0 = 10km,
    ** 1.0 = 1km, 0.5 = 500m, 0.05 = 50m and so on
    */
    return geo
        .collection(collectionRef: bonfireCollection)
        .within(
            center: center, radius: radius, field: 'position', strictMode: true)
        .transform(StreamTransformer<List<DocumentSnapshot>,
                List<Bonfire>>.fromHandlers(
            handleData: (List<DocumentSnapshot> documents,
                    EventSink<List<Bonfire>> sink) =>
                mapDocumentToBonfire(documents, sink)));
  }

  Future<void> mapDocumentToBonfire(
    List<DocumentSnapshot> documents,
    EventSink<List<Bonfire>> sink,
  ) async {
    final List<Bonfire> bonfires = <Bonfire>[];
    for (final DocumentSnapshot document in documents) {
      if (document['expired'] == false) {
        bonfires.add(Bonfire.fromFireStore(document));
      }
    }
    sink.add(bonfires);
  }

  @override
  Stream<List<Bonfire>> getUserBonfires(String sessionUid) {
    return _firestore
        .collection(Paths.bonfiresPath)
        .where('userId', isEqualTo: sessionUid)
        .where('expired', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Bonfire>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Bonfire>> sink) =>
                    mapQueryToBonfire(querySnapshot, sink)));
  }

  Future<void> mapQueryToBonfire(
    QuerySnapshot querySnapshot,
    EventSink<List<Bonfire>> sink,
  ) async {
    final List<Bonfire> bonfires = <Bonfire>[];
    for (final DocumentSnapshot document in querySnapshot.documents) {
      if (document['expired'] == false) {
        bonfires.add(Bonfire.fromFireStore(document));
      }
    }
    sink.add(bonfires);
  }

  @override
  Future<void> lightBonfire(Bonfire bonfire) async {
    final CollectionReference bonfireCollection =
        _firestore.collection(Paths.bonfiresPath);
    final DocumentReference ref = await bonfireCollection.add(bonfire.toMap());
    await ref.setData({'id': ref.documentID}, merge: true);
  }

  @override
  Future<void> updateBonfireRating(
      String id, List<String> likes, List<String> dislikes) async {
    final DocumentReference ref =
        _firestore.collection(Paths.bonfiresPath).document(id);
    await ref.setData({'likes': likes, 'dislikes': dislikes}, merge: true);
  }

  @override
  Future<void> updateBonfireExpirationDate(
      String id, int hours, int mode) async {
    final DocumentReference ref =
        _firestore.collection(Paths.bonfiresPath).document(id);
    final DocumentSnapshot documentSnapshot = await ref.get();

    final int createdAt = documentSnapshot.data['createdAt'] as int;
    final int expiresAt = documentSnapshot.data['expiresAt'] as int;

    final DateTime initialExpirationDate =
        DateTime.fromMicrosecondsSinceEpoch(createdAt) + 1.days;
    final DateTime expiresAtAsDate = DateTime.fromMillisecondsSinceEpoch(expiresAt);

    DateTime newExpirationDate;
    if (mode == 0) {
      newExpirationDate = expiresAtAsDate + hours.hours;
    } else {
      if ((expiresAtAsDate - hours.hours).millisecondsSinceEpoch >=
          initialExpirationDate.millisecondsSinceEpoch) {
        newExpirationDate = expiresAtAsDate - hours.hours;
      } else {
        newExpirationDate = expiresAtAsDate;
      }
    }
    await ref.setData({
      'expiresAt': newExpirationDate.millisecondsSinceEpoch,
    }, merge: true);
  }

  @override
  Future<void> updateBonfireExpiration(String id) async {
    final DocumentReference ref =
        _firestore.collection(Paths.bonfiresPath).document(id);
    await ref.setData({'expired': true}, merge: true);
  }

  @override
  Future<void> updateBonfireViewedBy(String id, List<String> usernames) async {
    final DocumentReference ref =
        _firestore.collection(Paths.bonfiresPath).document(id);
    await ref.setData({'viewedBy': usernames}, merge: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
