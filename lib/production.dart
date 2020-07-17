import 'package:bonfire/production_app.dart';
import 'package:bonfire/blocs/auth/auth_bloc.dart';
import 'package:bonfire/blocs/bonfire/bonfire_bloc.dart';
import 'package:bonfire/blocs/complete_profile/complete_profile_bloc.dart';
import 'package:bonfire/blocs/dark_mode/dark_mode_bloc.dart';
import 'package:bonfire/blocs/light_bonfire/light_bonfire_bloc.dart';
import 'package:bonfire/blocs/map/map_bloc.dart';
import 'package:bonfire/blocs/map/map_event.dart';
import 'package:bonfire/blocs/my_profile/my_profile_bloc.dart';
import 'package:bonfire/blocs/settings/settings_bloc.dart';
import 'package:bonfire/blocs/splash/splash_bloc.dart';
import 'package:bonfire/blocs/splash/splash_event.dart';
import 'package:bonfire/pages/store/bloc/store_bloc.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();
  await _localStorageRepository?.initLocalStorageService();

  createRoutes();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SplashBloc>(
        create: (BuildContext context) => SplashBloc()..add(EVTOnRequestPermissions()),
      ),
      BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
      BlocProvider<CompleteProfileBloc>(create: (BuildContext context) => CompleteProfileBloc()),
      BlocProvider<MyProfileBloc>(create: (BuildContext context) => MyProfileBloc()),
      BlocProvider<StoreBloc>(create: (BuildContext context) => StoreBloc()),
      BlocProvider<MapBloc>(
        create: (BuildContext context) => MapBloc()..add(OnFetchPositionEvent()),
      ),
      BlocProvider<LightBonfireBloc>(create: (BuildContext context) => LightBonfireBloc()),
      BlocProvider<BonfireBloc>(create: (BuildContext context) => BonfireBloc()),
      BlocProvider<SettingsBloc>(create: (BuildContext context) => SettingsBloc()),
      BlocProvider<DarkModeBloc>(create: (BuildContext context) => DarkModeBloc())
    ],
    child: ProductionApp(),
  ));
}
