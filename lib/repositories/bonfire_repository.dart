import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/services/bonfire/base_bonfire_service.dart';
import 'package:bonfire/services/bonfire/firebase_bonfire_service.dart';
import 'package:geolocator/geolocator.dart';

class BonfireRepository {
  factory BonfireRepository() => _singleton;

  final BaseBonfireService _bonfireService = FirebaseBonfireService();

  static final BonfireRepository _singleton = BonfireRepository._internal();

  BonfireRepository._internal();

  Stream<List<Bonfire>> getBonfires(Position position, double radius) =>
      _bonfireService.getBonfires(position, radius);

  Stream<List<Bonfire>> getUserBonfires(String sessionUid) =>
      _bonfireService.getUserBonfires(sessionUid);

  Future<void> lightBonfire(Bonfire bonfire) =>
      _bonfireService.lightBonfire(bonfire);

  Future<void> updateBonfireRating(
          String id, List<String> likes, List<String> dislikes) =>
      _bonfireService.updateBonfireRating(id, likes, dislikes);

  Future<void> updateBonfireExpirationDate(String id, int hours, int mode) =>
      _bonfireService.updateBonfireExpirationDate(id, hours, mode);

  Future<void> updateBonfireExpiration(String id) =>
      _bonfireService.updateBonfireExpiration(id);

  Future<void> updateBonfireViewedBy(String id, List<String> usernames) =>
      _bonfireService.updateBonfireViewedBy(id, usernames);
}
