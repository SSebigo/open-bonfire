import 'package:bonfire/models/skin.dart';
import 'package:bonfire/services/skin/base_skin_service.dart';
import 'package:bonfire/services/skin/firebase_skin_service.dart';

class OnlineSkinRepository {
  final BaseOnlineSkinService _onlineSkinService = FirebaseSkinService();

  static final OnlineSkinRepository _singleton =
      OnlineSkinRepository._internal();

  OnlineSkinRepository._internal();

  factory OnlineSkinRepository() => _singleton;

  Future<Skin> getSkinDetails(String skinUniqueName) =>
      _onlineSkinService.getSkinDetails(skinUniqueName);
}
