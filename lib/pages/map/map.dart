import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rounded_modal/rounded_modal.dart';

import 'package:bonfire/blocs/dark_mode/bloc.dart';
import 'package:bonfire/blocs/light_bonfire/bloc.dart';
import 'package:bonfire/blocs/map/bloc.dart';
import 'package:bonfire/blocs/splash/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/map/widgets/daily_quest_penalty_button.dart';
import 'package:bonfire/pages/map/widgets/light_bonfire_button.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/widgets/circle_button.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Logger logger = Logger();
  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();

  final Map<String, Bonfire> _bonfiresMap = <String, Bonfire>{};

  final List<String> _bottomSheetImages = <String>[];

  MapboxMapController _mapController;

  bool _darkMode, _isAnonymous;

  Map<String, dynamic> _dailyQuest;
  bool _completed;

  Map<String, dynamic> _skin;
  String _skinUniqueName;

  @override
  void initState() {
    super.initState();

    _dailyQuest = _localStorageRepository?.getUserSessionData(Constants.sessionDailyQuest) as Map<String, dynamic>;
    _completed = _localStorageRepository?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;

    _darkMode = _localStorageRepository?.getSessionConfigData(Constants.configDarkMode) as bool;
    _isAnonymous = _localStorageRepository?.getUserSessionData(Constants.sessionIsAnonymous) as bool;

    _skinUniqueName =
        _localStorageRepository?.getUserSessionData(Constants.sessionSkinUniqueName) as String ?? 'default';

    _skin = _localStorageRepository?.getSkinData(Constants.skin) as Map<String, dynamic>;

    _bottomSheetImages.addAll([
      _skin['fileIconUrl'] as String,
      _skin['imageIconUrl'] as String,
      _skin['videoIconUrl'] as String,
      _skin['textIconUrl'] as String,
      // _skin['arIconUrl],
    ]);

    BlocProvider.of<MapBloc>(context).add(OnFetchInitialPositionEvent());
    BlocProvider.of<MapBloc>(context).add(const OnFetchBonfiresEvent());
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    _mapController.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onSymbolTapped(Symbol symbol) {
    final Bonfire bonfire = _bonfiresMap[symbol.id];
    BlocProvider.of<MapBloc>(context).add(OnBonfireClickedEvent(bonfire: bonfire));
  }

  void _onMyProfileClicked() {
    if (_isAnonymous == true) {
      sailor(Constants.authRoute);
    } else {
      sailor(Constants.profileRoute);
    }
  }

  void _onLightBonfireClicked(int type) {
    BlocProvider.of<MapBloc>(context).add(OnLightBonfireClickedEvent(type: type));
  }

  CircularProfileAvatar _buildProfileAvatar() {
    final String pictureUrl = _localStorageRepository?.getUserSessionData(Constants.sessionProfilePictureUrl) as String;

    return CircularProfileAvatar(
      pictureUrl == null || pictureUrl.isEmpty ? _skin['avatarIconUrl'] as String : pictureUrl,
      radius: 20.0,
      backgroundColor: Colors.white,
      cacheImage: true,
      onTap: _onMyProfileClicked,
    );
  }

  Align _buildLightBonfireButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Tooltip(
          message: I18n.of(context).textLightBonfire,
          textStyle: GoogleFonts.varelaRound(textStyle: TextStyle(color: Colors.white)),
          child: CircleButton(
            onTap: () => _showModalBottomSheet(context),
            width: 200.0 / MediaQuery.of(context).devicePixelRatio,
            height: 200.0 / MediaQuery.of(context).devicePixelRatio,
            imagePath:
                _darkMode == true ? _skin['circleButtonLightUrl'] as String : _skin['circleButtonDarkUrl'] as String,
          ),
        ),
      ),
    );
  }

  String _getBottomSheetText(BuildContext context, int idx) {
    switch (idx) {
      case 0:
        return I18n.of(context).textFile;
        break;
      case 1:
        return I18n.of(context).textImage;
        break;
      case 2:
        return I18n.of(context).textVideo;
        break;
      case 3:
        return I18n.of(context).textText;
        break;
      // case 4:
      //   return 'AR\nComing';
      //   break;
      default:
    }
    return '';
  }

  void _showModalBottomSheet(BuildContext context) {
    showRoundedModalBottomSheet(
      context: context,
      radius: 20.0,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      I18n.of(context).textLightBonfire,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150.0,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _bottomSheetImages.length,
                    itemBuilder: (_, int idx) {
                      return Padding(
                        padding: idx == 0
                            ? const EdgeInsets.symmetric(horizontal: 22.0)
                            : const EdgeInsets.only(right: 22.0),
                        child: Center(
                          child: LightBonfireButton(
                            onTap: () => _onLightBonfireClicked(idx),
                            imagePath: _bottomSheetImages[idx],
                            text: _getBottomSheetText(context, idx),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createSymbols(List<Bonfire> bonfires) async {
    await _mapController.clearSymbols();
    _bonfiresMap.clear();
    for (final Bonfire bonfire in bonfires) {
      String icon;
      final bool viewed =
          bonfire.viewedBy.contains(_localStorageRepository.getUserSessionData(Constants.sessionUsername));
      if (bonfire is ImageBonfire) {
        icon = viewed
            ? 'assets/skins/$_skinUniqueName/image-icon-viewed.png'
            : 'assets/skins/$_skinUniqueName/image-icon.png';
      } else if (bonfire is VideoBonfire) {
        icon = viewed
            ? 'assets/skins/$_skinUniqueName/video-icon-viewed.png'
            : 'assets/skins/$_skinUniqueName/video-icon.png';
      } else if (bonfire is TextBonfire) {
        icon = viewed
            ? 'assets/skins/$_skinUniqueName/text-icon-viewed.png'
            : 'assets/skins/$_skinUniqueName/text-icon.png';
      } else if (bonfire is FileBonfire) {
        icon = viewed
            ? 'assets/skins/$_skinUniqueName/file-icon-viewed.png'
            : 'assets/skins/$_skinUniqueName/file-icon.png';
      }
      final Symbol symbol = await _mapController.addSymbol(
        SymbolOptions(
          geometry: LatLng(bonfire.position.latitude, bonfire.position.longitude),
          iconImage: icon,
          iconSize: 0.3,
        ),
      );
      _bonfiresMap[symbol.id] = bonfire;
    }
  }

  void _getDailyQuestNavigationPath() {
    if (_dailyQuest == null) {
      sailor(Constants.profilePenaltyRoute);
    } else {
      sailor(Constants.profileDQRoute);
    }
  }

  String _getDailyQuestTooltipMessage() {
    if (_dailyQuest == null) {
      return '${I18n.of(context).textPenalty} ${I18n.of(context).textInProgress}';
    } else {
      return _completed == true
          ? '${I18n.of(context).textDailyQuest} ${I18n.of(context).textCompleted}'
          : '${I18n.of(context).textDailyQuest} ${I18n.of(context).textInProgress}';
    }
  }

  String _getDailyQuestPenaltyImagePath() {
    if (_dailyQuest == null) {
      return _skin['penaltyIconUrl'] as String;
    } else {
      return _completed == true ? _skin['questCompletedIconUrl'] as String : _skin['questInProgressIconUrl'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<MapBloc, MapState>(
              listener: (BuildContext context, MapState state) {
                if (state is FetchedInitialPositionState) {
                  _mapController.moveCamera(CameraUpdate.newLatLngZoom(
                    LatLng(state.position.latitude, state.position.longitude),
                    18.0,
                  ));
                }
                if (state is FetchedPositionState) {
                  _mapController.moveCamera(CameraUpdate.newLatLngZoom(
                    LatLng(state.position.latitude, state.position.longitude),
                    18.0,
                  ));
                  BlocProvider.of<MapBloc>(context).add(OnFetchBonfiresEvent(position: state.position));
                }
                if (state is FetchedBonfiresState) {
                  _createSymbols(state.bonfires);
                }
                if (state is NavigateToBonfireState) {
                  sailor.navigate(Constants.bonfireRoute, args: BonfireArgs(state.bonfire));
                }
                if (state is NavigationToLightBonfireFileState) {
                  sailor(Constants.lightBonfireFileRoute);
                }
                if (state is NavigationToLightBonfireImageState) {
                  sailor(Constants.lightBonfireImageRoute);
                }
                if (state is NavigationToLightBonfireVideoState) {
                  sailor(Constants.lightBonfireVideoRoute);
                }
                if (state is NavigationToLightBonfireTextState) {
                  sailor(Constants.lightBonfireTextRoute);
                }
              },
            ),
          ],
          child: Stack(
            children: <Widget>[
              BlocBuilder<DarkModeBloc, DarkModeState>(
                builder: (context, dmState) {
                  if (dmState is InitialDarkModeState) {
                    _darkMode = _localStorageRepository?.getSessionConfigData(Constants.configDarkMode) as bool;
                  }
                  if (dmState is DarkModeChanged) {
                    _darkMode = dmState.darkMode;
                  }
                  return MapboxMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    styleString: _darkMode ? MapboxStyles.DARK : MapboxStyles.LIGHT,
                    initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Row(
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.only(right: 15.0), child: _buildProfileAvatar()),
                  ],
                ),
              ),
              _buildLightBonfireButton(),
              if (_isAnonymous)
                Container()
              else
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0, right: 25.0),
                    child: BlocBuilder<LightBonfireBloc, LightBonfireState>(
                      bloc: BlocProvider.of<LightBonfireBloc>(context),
                      builder: (context, lightBonfireState) {
                        if (lightBonfireState is DailyQuestCompleted) {
                          _completed =
                              _localStorageRepository?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;
                        }
                        return BlocBuilder<SplashBloc, SplashState>(
                          builder: (context, splashState) {
                            if (splashState is STEBackgroundTaskDailyQuestOrPenaltyUpdated) {
                              _dailyQuest = _localStorageRepository?.getUserSessionData(Constants.sessionDailyQuest)
                                  as Map<String, dynamic>;
                              _completed =
                                  _localStorageRepository?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;
                            }
                            return DailyQuestPenaltyButton(
                              height: 50.0,
                              imagePath: _getDailyQuestPenaltyImagePath(),
                              onPressed: () => _getDailyQuestNavigationPath(),
                              tooltipMessage: _getDailyQuestTooltipMessage(),
                              width: 50.0,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              BlocBuilder<MapBloc, MapState>(
                builder: (context, state) {
                  if (state is FetchingBonfiresState) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 75.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
