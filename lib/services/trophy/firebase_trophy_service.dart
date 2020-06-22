import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/services/trophy/base_trophy_service.dart';
import 'package:bonfire/services/trophy/trophy_progress.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTrophyService extends BaseTrophyService {
  final Firestore _firestore = Firestore.instance;
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final TrophyProgress _trophyProgress = TrophyProgress();

  static final FirebaseTrophyService _singleton =
      FirebaseTrophyService._internal();

  FirebaseTrophyService._internal();

  factory FirebaseTrophyService() => _singleton;

  @override
  Future<List<Trophy>> getTrophies() async {
    final CollectionReference trophiesReference =
        _firestore.collection(Paths.trophiesPath);
    final querySnapshot = await trophiesReference.getDocuments();

    final List<Trophy> trophies = <Trophy>[];
    querySnapshot.documents
        .forEach((doc) => trophies.add(Trophy.fromFirestore(doc)));
    return trophies;
  }

  @override
  Future<void> updateTrophyProgress() async {
    final List<Trophy> trophies = _localStorageRepository
        ?.getUserSessionData(Constants.sessionMissingTrophies) as List<Trophy>;

    final int fileBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionFileBonfireCount) as int;
    final int imageBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionImageBonfireCount) as int;
    final int textBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionTextBonfireCount) as int;
    final int videoBonfireCount = _localStorageRepository
        ?.getUserSessionData(Constants.sessionVideoBonfireCount) as int;

    for (final Trophy trophy in trophies) {
      switch (trophy.uniqueName) {
        case 'trophy_all_iron':
          await _trophyProgress.updateTrophyAllIron(trophy.id,
              fileBonfireCount: fileBonfireCount,
              imageBonfireCount: imageBonfireCount,
              textBonfireCount: textBonfireCount,
              videoBonfireCount: videoBonfireCount);
          break;
        case 'trophy_all_bronze':
          await _trophyProgress.updateTrophyAllBronze(trophy.id,
              fileBonfireCount: fileBonfireCount,
              imageBonfireCount: imageBonfireCount,
              textBonfireCount: textBonfireCount,
              videoBonfireCount: videoBonfireCount);
          break;
        case 'trophy_all_silver':
          await _trophyProgress.updateTrophyAllSilver(trophy.id,
              fileBonfireCount: fileBonfireCount,
              imageBonfireCount: imageBonfireCount,
              textBonfireCount: textBonfireCount,
              videoBonfireCount: videoBonfireCount);
          break;
        case 'trophy_all_gold':
          await _trophyProgress.updateTrophyAllGold(trophy.id,
              fileBonfireCount: fileBonfireCount,
              imageBonfireCount: imageBonfireCount,
              textBonfireCount: textBonfireCount,
              videoBonfireCount: videoBonfireCount);
          break;
        case 'trophy_all_platinum':
          await _trophyProgress.updateTrophyAllPlatinum(trophy.id,
              fileBonfireCount: fileBonfireCount,
              imageBonfireCount: imageBonfireCount,
              textBonfireCount: textBonfireCount,
              videoBonfireCount: videoBonfireCount);
          break;
        case 'trophy_all_diamond':
          await _trophyProgress.updateTrophyAllDiamond(trophy.id,
              fileBonfireCount: fileBonfireCount,
              imageBonfireCount: imageBonfireCount,
              textBonfireCount: textBonfireCount,
              videoBonfireCount: videoBonfireCount);
          break;
        default:
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
