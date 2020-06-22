import 'package:bonfire/models/skin.dart';
import 'package:bonfire/services/skin/base_skin_service.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSkinService extends BaseOnlineSkinService {
  final Firestore _firestore = Firestore.instance;

  static final FirebaseSkinService _singleton =
      FirebaseSkinService._internal();

  FirebaseSkinService._internal();

  factory FirebaseSkinService() => _singleton;

  @override
  Future<Skin> getSkinDetails(String skinUniqueName) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(Paths.skinsPath)
        .where('uniqueName', isEqualTo: skinUniqueName)
        .getDocuments();
    final DocumentSnapshot doc = querySnapshot.documents[0];
    return Skin.fromFirestore(doc);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
