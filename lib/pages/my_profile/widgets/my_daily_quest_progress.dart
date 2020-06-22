import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDailyQuestProgress extends StatefulWidget {
  final LocalStorageRepository _localStorageRepository;

  const MyDailyQuestProgress({
    @required LocalStorageRepository localStorageRepository,
    Key key,
  })  : _localStorageRepository = localStorageRepository,
        super(key: key);

  @override
  _MyDailyQuestProgressState createState() => _MyDailyQuestProgressState();
}

class _MyDailyQuestProgressState extends State<MyDailyQuestProgress> {
  String _dailyQuestUniqueName;

  int _dayFileBonfireCount,
      _dayImageBonfireCount,
      _dayTextBonfireCount,
      _dayVideoBonfireCount,
      _totalBonfireCount;

  int _bonfireToLit;

  @override
  void initState() {
    _dailyQuestUniqueName = widget._localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestUniqueName) as String;

    _dayFileBonfireCount = widget._localStorageRepository
        ?.getUserSessionData(Constants.sessionDayFileBonfireCount) as int;
    _dayImageBonfireCount = widget._localStorageRepository
        ?.getUserSessionData(Constants.sessionDayImageBonfireCount) as int;
    _dayTextBonfireCount = widget._localStorageRepository
        ?.getUserSessionData(Constants.sessionDayTextBonfireCount) as int;
    _dayVideoBonfireCount = widget._localStorageRepository
        ?.getUserSessionData(Constants.sessionDayVideoBonfireCount) as int;
    _totalBonfireCount = _dayFileBonfireCount +
        _dayImageBonfireCount +
        _dayTextBonfireCount +
        _dayVideoBonfireCount;

    _bonfireToLit = widget._localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_dailyQuestUniqueName) {
      case 'master_of_bonfires':
        return Text(
          '${I18n.of(context).textTotal.toUpperCase()}: $_totalBonfireCount/$_bonfireToLit',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15.0,
            ),
          ),
        );
        break;
      case 'master_of_files':
        return Text(
          '${I18n.of(context).textFile.toUpperCase()}: $_dayFileBonfireCount/$_bonfireToLit',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15.0,
            ),
          ),
        );
        break;
      case 'master_of_images':
        return Text(
          '${I18n.of(context).textImage.toUpperCase()}: $_dayImageBonfireCount/$_bonfireToLit',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15.0,
            ),
          ),
        );
        break;
      case 'master_of_texts':
        return Text(
          '${I18n.of(context).textText.toUpperCase()}: $_dayTextBonfireCount/$_bonfireToLit',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15.0,
            ),
          ),
        );
        break;
      case 'master_of_videos':
        return Text(
          '${I18n.of(context).textVideo.toUpperCase()}: $_dayVideoBonfireCount/$_bonfireToLit',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15.0,
            ),
          ),
        );
        break;
      default:
        return Container();
    }
  }
}
