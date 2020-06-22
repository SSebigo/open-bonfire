import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/services/base_service.dart';
import 'package:geolocator/geolocator.dart';

abstract class BaseBonfireService extends BaseService {
  Stream<List<Bonfire>> getBonfires(Position position, double radius);
  Stream<List<Bonfire>> getUserBonfires(String sessionUid);
  Future<void> lightBonfire(Bonfire bonfire);
  Future<void> updateBonfireRating(String id, List<String> likes, List<String> dislikes);
  Future<void> updateBonfireExpirationDate(String id, int hours, int mode);
  Future<void> updateBonfireExpiration(String id);
  Future<void> updateBonfireViewedBy(String id, List<String> username);
}
