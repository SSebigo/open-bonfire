import 'package:bonfire/blocs/dark_mode/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/pages/splash/index.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sailor/sailor.dart';

class DevelopmentApp extends StatefulWidget {
  @override
  _DevelopmentAppState createState() => _DevelopmentAppState();
}

class _DevelopmentAppState extends State<DevelopmentApp> {
  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (context, state) {
        if (state is InitialDarkModeState) {
          _theme = _localStorageRepository?.getSessionConfigData(Constants.configDarkMode) as bool
              ? Themes.dark
              : Themes.light;
        }
        if (state is DarkModeChanged) {
          _theme = state.darkMode ? Themes.dark : Themes.light;
        }
        return MaterialApp(
          title: 'Bonfire Dev',
          localizationsDelegates: [
            const I18nDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: I18nDelegate.supportedLocals,
          theme: _theme,
          home: SplashPage(),
          onGenerateRoute: sailor.generator(),
          navigatorKey: sailor.navigatorKey,
          navigatorObservers: [SailorLoggingObserver()],
        );
      },
    );
  }
}
