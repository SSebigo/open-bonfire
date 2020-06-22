import 'dart:math';

import 'package:bonfire/models/penalty.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/services/penalty/base_penalty_service.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time/time.dart';

class FirebasePenaltyService extends BasePenaltyService {
  final Firestore _firestore = Firestore.instance;
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  static final FirebasePenaltyService _singleton =
      FirebasePenaltyService._internal();

  FirebasePenaltyService._internal();

  factory FirebasePenaltyService() => _singleton;

  @override
  Future<List<Penalty>> getPenalties() async {
    final CollectionReference penaltiesReference =
        _firestore.collection(Paths.penaltiesPath);
    final querySnapshot = await penaltiesReference.getDocuments();

    final List<Penalty> penalties = <Penalty>[];
    querySnapshot.documents
        .forEach((doc) => penalties.add(Penalty.fromFirestore(doc)));
    return penalties;
  }

  @override
  Future<Penalty> getRandomPenalty(String previousPenaltyId) async {
    final List<Penalty> penalties = (await getPenalties())
        .where((item) => item.id != previousPenaltyId)
        .toList();
    final Random rnd = Random();
    final int idx = rnd.nextInt(penalties.length);
    final Penalty rPenalty = penalties[idx];
    return rPenalty;
  }

  @override
  Future<Penalty> getPenaltyById(String id) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(Paths.penaltiesPath)
        .where('id', isEqualTo: id)
        .getDocuments();
    final DocumentSnapshot doc = querySnapshot.documents[0];
    return Penalty.fromFirestore(doc);
  }

  @override
  Future<void> updatePenalty() async {
    final String previousPenaltyId = _localStorageRepository
        ?.getDailyQuestData(Constants.penaltyPreviousPenaltyId) as String;
    final Penalty penalty = await getRandomPenalty(previousPenaltyId);

    await _localStorageRepository?.setPenalty(
      penalty,
      previousPenaltyId: previousPenaltyId,
      deadline: (DateTime.now() + 4.hours).millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> updatePenaltyById(int deadline, String id) async {
    final Penalty penalty = await getPenaltyById(id);

    await _localStorageRepository?.setPenalty(
      penalty,
      deadline: deadline,
      previousPenaltyId: id,
    );
  }

  @override
  Future<void> nullifyPenalty() async {
    await _localStorageRepository?.setPenalty(
        Penalty(description: null, id: null, title: null, uniqueName: null),
        deadline: null,
        previousPenaltyId: null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
