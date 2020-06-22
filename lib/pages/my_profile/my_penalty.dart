import 'package:bonfire/blocs/my_profile/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class MyPenaltyPage extends StatefulWidget {
  @override
  _MyPenaltyPageState createState() => _MyPenaltyPageState();
}

class _MyPenaltyPageState extends State<MyPenaltyPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  Map<String, dynamic> _title;
  Map<String, dynamic> _description;
  int _deadline;

  String _locale;

  Map<String, dynamic> _skin;

  @override
  void initState() {
    _title = _localStorageRepository?.getPenaltyData(Constants.penaltyTitle)
        as Map<String, dynamic>;
    _description = _localStorageRepository
        ?.getPenaltyData(Constants.penaltyDescription) as Map<String, dynamic>;
    _deadline = _localStorageRepository
        ?.getPenaltyData(Constants.penaltyDeadline) as int;

    _locale = _localStorageRepository
        ?.getSessionConfigData(Constants.configLocale) as String;

    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          '${I18n.of(context).textPenalty} ${I18n.of(context).textInProgress}',
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
                          '${I18n.of(context).textPenaltyDescription}:',
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
                              '${_description[_locale]}',
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
