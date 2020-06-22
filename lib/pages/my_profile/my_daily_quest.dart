import 'package:bonfire/blocs/my_profile/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/pages/my_profile/widgets/my_daily_quest_progress.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class MyDailyQuestPage extends StatefulWidget {
  @override
  _MyDailyQuestPageState createState() => _MyDailyQuestPageState();
}

class _MyDailyQuestPageState extends State<MyDailyQuestPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  Map<String, dynamic> _description, _title;
  int _bonfireToLit, _deadline, _experience;
  bool _completed, _progressive;

  String _locale;

  Map<String, dynamic> _skin;

  @override
  void initState() {
    super.initState();
    _description = _localStorageRepository?.getDailyQuestData(
        Constants.dailyQuestDescription) as Map<String, dynamic>;
    _title = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestTitle) as Map<String, dynamic>;

    _bonfireToLit = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestBonfireToLit) as int;
    _deadline = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestDeadline) as int;
    _experience = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestExperience) as int;

    _completed = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;
    _progressive = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestProgressive) as bool;

    _locale = _localStorageRepository
        ?.getSessionConfigData(Constants.configLocale) as String;

    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          '${I18n.of(context).textDailyQuest} ${_completed == true ? I18n.of(context).textCompleted : I18n.of(context).textInProgress}',
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MyProfileBloc, MyProfileState>(
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                CachedNetworkImage(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                  height: double.infinity,
                  imageUrl: _skin['borderUrl'] as String,
                  width: double.infinity,
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 50.0),
                        child: Text(
                          '${_title[_locale]}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 50.0),
                        child: Text(
                          '${I18n.of(context).textQuestDirections}:',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _progressive == true
                                  ? _description[_locale]?.replaceAll(
                                          '{:?}', _bonfireToLit.toString())
                                      as String
                                  : _description[_locale] as String,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 50.0),
                        child: Text(
                          '${I18n.of(context).textExperience}:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
                        child: Text(
                          '${_experience}XP',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 25.0),
                        child: Text(
                          '${I18n.of(context).textStatus}:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
                        child: Text(
                          _completed == true
                              ? I18n.of(context).textCompleted.toUpperCase()
                              : I18n.of(context).textInProgress.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: _completed == true
                                  ? PaletteFour.colorOne
                                  : PaletteFour.colorTwo,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
                        child: MyDailyQuestProgress(
                          localStorageRepository: _localStorageRepository,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 25.0),
                        child: Text(
                          '${I18n.of(context).textDeadline}:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
                        child: Text(
                          Jiffy(DateTime.fromMillisecondsSinceEpoch(_deadline))
                              .yMMMMEEEEdjm,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 25.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.varelaRound(
                              textStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20.0,
                              ),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${I18n.of(context).textWarning}: ',
                                style: TextStyle(
                                  color: PaletteTwo.colorFour,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '${I18n.of(context).textWarningDescription1}.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
