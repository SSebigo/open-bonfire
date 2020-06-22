import 'package:bonfire/models/penalty.dart';
import 'package:bonfire/services/penalty/base_penalty_service.dart';
import 'package:bonfire/services/penalty/firebase_penalty_service.dart';

class PenaltyRepository {
  final BasePenaltyService _penaltyService = FirebasePenaltyService();

  static final PenaltyRepository _singleton = PenaltyRepository._internal();

  PenaltyRepository._internal();

  factory PenaltyRepository() => _singleton;

  Future<List<Penalty>> getPenalties() => _penaltyService.getPenalties();

  Future<Penalty> getRandomPenalty(String previousPenaltyId) =>
      _penaltyService.getRandomPenalty(previousPenaltyId);

  Future<Penalty> getPenaltyById(String id) =>
      _penaltyService.getPenaltyById(id);

  Future<void> updatePenalty() => _penaltyService.updatePenalty();

  Future<void> updatePenaltyById(
    int deadline,
    String id,
  ) =>
      _penaltyService.updatePenaltyById(deadline, id);

  Future<void> nullifyPenalty() => _penaltyService.nullifyPenalty();
}
