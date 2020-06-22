import 'package:bonfire/blocs/my_profile/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/my_profile/widgets/file_bonfire_card.dart';
import 'package:bonfire/pages/my_profile/widgets/image_bonfire_card.dart';
import 'package:bonfire/pages/my_profile/widgets/text_bonfire_card.dart';
import 'package:bonfire/pages/my_profile/widgets/video_bonfire_card.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBonfiresPage extends StatefulWidget {
  @override
  _MyBonfiresPageState createState() => _MyBonfiresPageState();
}

class _MyBonfiresPageState extends State<MyBonfiresPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  List<Bonfire> _bonfires = <Bonfire>[];
  Map<String, dynamic> _skin;
  final List<String> _bonfireImagePaths = <String>[];

  DateTime _now;
  String _locale;

  @override
  void initState() {
    super.initState();
    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    _bonfireImagePaths.addAll([
      _skin['fileIconUrl'] as String,
      _skin['imageIconUrl'] as String,
      _skin['textIconUrl'] as String,
      _skin['videoIconUrl'] as String,
      // _slin['arIconUrl],
    ]);

    _now = DateTime.now();

    _locale = _localStorageRepository
        ?.getSessionConfigData(Constants.configLocale) as String;

    BlocProvider.of<MyProfileBloc>(context).add(EVTOnFetchUserBonfires());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          I18n.of(context).textMyBonfires,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<MyProfileBloc, MyProfileState>(
          listener: (context, state) {
            if (state is STEFetchedUserBonfires) {
              _bonfires = state.bonfires;
            }
          },
          child: BlocBuilder<MyProfileBloc, MyProfileState>(
              builder: (context, state) {
            if (_bonfires.isEmpty) {
              return Center(
                child: Text(
                  I18n.of(context).textNothingHere,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              );
            }
            return Container(
              width: double.infinity,
              child: ListView.builder(
                itemCount: _bonfires.length,
                itemBuilder: (_, int idx) {
                  if (_bonfires[idx] is FileBonfire) {
                    return FileBonfireCard(
                      bonfire: _bonfires[idx] as FileBonfire,
                      imagePath: _bonfireImagePaths[0],
                      locale: _locale,
                      now: _now,
                      onPressed: () => sailor.navigate(
                        Constants.bonfireRoute,
                        args: BonfireArgs(_bonfires[idx]),
                      ),
                    );
                  } else if (_bonfires[idx] is ImageBonfire) {
                    return ImageBonfireCard(
                      bonfire: _bonfires[idx] as ImageBonfire,
                      imagePath: _bonfireImagePaths[1],
                      locale: _locale,
                      now: _now,
                      onPressed: () => sailor.navigate(
                        Constants.bonfireRoute,
                        args: BonfireArgs(_bonfires[idx]),
                      ),
                    );
                  } else if (_bonfires[idx] is TextBonfire) {
                    return TextBonfireCard(
                      bonfire: _bonfires[idx] as TextBonfire,
                      imagePath: _bonfireImagePaths[2],
                      locale: _locale,
                      now: _now,
                      onPressed: () => sailor.navigate(
                        Constants.bonfireRoute,
                        args: BonfireArgs(_bonfires[idx]),
                      ),
                    );
                  } else if (_bonfires[idx] is VideoBonfire) {
                    return VideoBonfireCard(
                      bonfire: _bonfires[idx] as VideoBonfire,
                      imagePath: _bonfireImagePaths[3],
                      locale: _locale,
                      now: _now,
                      onPressed: () => sailor.navigate(
                        Constants.bonfireRoute,
                        args: BonfireArgs(_bonfires[idx]),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
