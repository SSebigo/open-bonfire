import 'package:bonfire/blocs/dark_mode/bloc.dart';
import 'package:bonfire/blocs/settings/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/widgets/bonfire_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:sailor/sailor.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  String _username = '';

  String _appName = '';
  String _version = '';

  bool _darkMode;

  @override
  void initState() {
    _username = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUsername) as String;
    _getPackageInfo();
    super.initState();
  }

  Future<void> _getPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _appName = packageInfo.appName;
      _version = packageInfo.version;
    });
  }

  void _toggleDarkMode() {
    BlocProvider.of<DarkModeBloc>(context)
        .add(OnDarkModeToggled(darkMode: _darkMode));
  }

  void _onLogoutClicked() {
    BlocProvider.of<SettingsBloc>(context).add(OnLogoutClicked());
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => BonfireDialog(
        title: I18n.of(context).textSureLogout,
        titleButton1: I18n.of(context).buttonCancel,
        onPressedButton1: () {
          Navigator.of(context).pop();
        },
        titleButton2: I18n.of(context).buttonImSure,
        onPressedButton2: _onLogoutClicked,
        width: 300.0,
        height: 200.0,
      ),
    );
  }

  Container _buildVersionAndMadeIn() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                '$_appName v$_version',
                textAlign: TextAlign.center,
                style: GoogleFonts.varelaRound(
                  textStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Text(
              'Made in Montpellier',
              textAlign: TextAlign.center,
              style: GoogleFonts.varelaRound(
                textStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          I18n.of(context).textSettings,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<SettingsBloc, SettingsState>(
          bloc: BlocProvider.of<SettingsBloc>(context),
          listener: (context, state) {
            if (state is LoggingOutState) {
              Flushbar(
                message: I18n.of(context).textLoggingOut,
                icon: Icon(Icons.file_upload, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
            if (state is LoggedOutState) {
              sailor.navigate(
                Constants.authAnonymousRoute,
                navigationType: NavigationType.pushAndRemoveUntil,
                removeUntilPredicate: (_) => false,
              );
            }
            if (state is SettingsFailedState) {
              Flushbar(
                title: I18n.of(context).textErrorOccured,
                message: state.error.message as String,
                icon: Icon(Icons.error_outline, color: Colors.redAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.redAccent,
              ).show(context);
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            bloc: BlocProvider.of<SettingsBloc>(context),
            builder: (context, state) {
              return ListView(
                children: <Widget>[
                  // SECTION MY ACCOUNT
                  Container(
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      title: Text(
                        I18n.of(context).textMyAccount.toUpperCase(),
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textName,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          _localStorageRepository?.getUserSessionData(
                                  Constants.sessionName) as String ??
                              '',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                    onTap: () => sailor(Constants.settingsNameRoute),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textUsername,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Text(
                      '@$_username',
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textEmail,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          _localStorageRepository?.getUserSessionData(
                                  Constants.sessionEmail) as String ??
                              '',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                    onTap: () => sailor(Constants.settingsEmailRoute),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textPassword,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => sailor(Constants.settingsPasswordRoute),
                  ),
                  BlocBuilder<DarkModeBloc, DarkModeState>(
                    builder: (context, state) {
                      if (state is InitialDarkModeState) {
                        _darkMode = _localStorageRepository
                                ?.getSessionConfigData(Constants.configDarkMode)
                            as bool;
                      }
                      if (state is DarkModeChanged) {
                        _darkMode = state.darkMode;
                      }
                      return ListTile(
                        title: Text(
                          I18n.of(context).textDarkMode,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          _darkMode
                              ? WeatherIcons.wi_night_clear
                              : WeatherIcons.wi_day_sunny,
                          color: Theme.of(context).accentColor,
                        ),
                        onTap: _toggleDarkMode,
                      );
                    },
                  ),
                  // SECTION PRIVACY
                  Container(
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      title: Text(
                        I18n.of(context).textPrivacy.toUpperCase(),
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     I18n.of(context).textPermissions,
                  //     style: GoogleFonts.varelaRound(
                  //       textStyle: TextStyle(
                  //         color: Theme.of(context).accentColor,
                  //       ),
                  //     ),
                  //   ),
                  //   trailing: Icon(
                  //     Icons.keyboard_arrow_right,
                  //     color: Theme.of(context).accentColor,
                  //   ),
                  //   onTap: () => Navigator.of(context).pushNamed('/settings/edit-permissions'),
                  // ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textMyData,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => sailor(Constants.settingsDataRoute),
                  ),
                  // SECTION Support
                  Container(
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      title: Text(
                        I18n.of(context).textSupport.toUpperCase(),
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textReportProblem,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => sailor(Constants.settingsReportRoute),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textGiveFeedback,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => sailor(Constants.settingsFeedbackRoute),
                  ),
                  // SECTION More Information
                  Container(
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      title: Text(
                        I18n.of(context).textMoreInfo.toUpperCase(),
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textTermsOfService,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => sailor(Constants.authTOSRoute),
                  ),
                  ListTile(
                    title: Text(
                      I18n.of(context).textPrivacyPolicy,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => sailor(Constants.authPPRoute),
                  ),
                  // SECTION More Information
                  Container(
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      title: Text(
                        I18n.of(context).textAccountActions.toUpperCase(),
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     I18n.of(context).clearCache,
                  //     style: GoogleFonts.varelaRound(
                  //       textStyle: TextStyle(
                  //         color: Theme.of(context).accentColor,
                  //       ),
                  //     ),
                  //   ),
                  //   onTap: () {},
                  // ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app,
                        color: Theme.of(context).accentColor),
                    title: Text(
                      I18n.of(context).textLogout,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    onTap: _showConfirmationDialog,
                  ),
                  _buildVersionAndMadeIn(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
