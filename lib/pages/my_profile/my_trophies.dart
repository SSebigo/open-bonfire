import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/pages/my_profile/widgets/completed_trophy_card.dart';
import 'package:bonfire/pages/my_profile/widgets/trophy_dialog.dart';
import 'package:bonfire/pages/my_profile/widgets/incompleted_trophy_card.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTrophiesPage extends StatefulWidget {
  @override
  _MyTrophiesPageState createState() => _MyTrophiesPageState();
}

class _MyTrophiesPageState extends State<MyTrophiesPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  List<Trophy> _trophies;
  List<String> _sessionTrophies;

  String _locale;

  @override
  void initState() {
    super.initState();
    _trophies = _localStorageRepository?.getTrophiesData(Constants.trophies)
        as List<Trophy>;
    _sessionTrophies = _localStorageRepository
        ?.getUserSessionData(Constants.sessionTrophies) as List<String>;

    _locale = _localStorageRepository
        ?.getSessionConfigData(Constants.configLocale) as String;
  }

  List<StaggeredTile> _generateStaggeredTiles() {
    final List<StaggeredTile> staggeredTiles = <StaggeredTile>[];

    _trophies.forEach((item) {
      staggeredTiles.add(const StaggeredTile.count(1, 1));
    });

    return staggeredTiles;
  }

  List<Widget> _generateTiles() {
    final List<Widget> tiles = <Widget>[];

    _trophies.forEach((trophy) {
      final bool completed = _sessionTrophies?.contains(trophy.id);

      tiles.add(
        completed == true
            ? CompletedTrophyCard(
                iconUrl: trophy.iconUrl,
                onPressed: () => _showTrophyDialog(trophy, completed),
              )
            : IncompletedTrophyCard(
                iconUrl: trophy.iconUrl,
                onPressed: () => _showTrophyDialog(trophy, completed),
              ),
      );
    });

    return tiles;
  }

  void _showTrophyDialog(Trophy trophy, bool completed) {
    showDialog(
      context: context,
      builder: (_) => TrophyDialog(
        completed: completed,
        locale: _locale,
        trophy: trophy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          I18n.of(context).textMyTrophies,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: StaggeredGridView.count(
          crossAxisCount: 6,
          staggeredTiles: _generateStaggeredTiles(),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: _generateTiles(),
        ),
      ),
    );
  }
}
