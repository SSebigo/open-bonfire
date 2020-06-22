import 'package:bonfire/models/penalty.dart';
import 'package:bonfire/services/base_service.dart';

abstract class BasePenaltyService extends BaseService {
  Future<List<Penalty>> getPenalties();
  Future<Penalty> getRandomPenalty(String previousPenaltyId);
  Future<Penalty> getPenaltyById(String id);
  Future<void> updatePenalty();
  Future<void> updatePenaltyById(int deadline, String id);
  Future<void> nullifyPenalty();
}
