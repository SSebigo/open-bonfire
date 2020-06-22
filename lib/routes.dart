import 'package:bonfire/pages/auth/index.dart';
import 'package:bonfire/pages/bonfire/index.dart';
import 'package:bonfire/pages/complete_profile/complete_profile.dart';
import 'package:bonfire/pages/light_bonfire/index.dart';
import 'package:bonfire/pages/map/map.dart';
import 'package:bonfire/pages/my_profile/index.dart';
import 'package:bonfire/pages/privacy_policy/privacy_policy.dart';
import 'package:bonfire/pages/search/search.dart';
import 'package:bonfire/pages/settings/index.dart';
import 'package:bonfire/pages/splash/splash.dart';
import 'package:bonfire/pages/store/index.dart';
import 'package:bonfire/pages/terms_of_service/terms_of_service.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:sailor/sailor.dart';

final Sailor sailor = Sailor();

void createRoutes() {
  sailor.addRoutes([
    SailorRoute(
      name: Constants.splashRoute,
      builder: (context, args, params) => SplashPage(),
    ),
    SailorRoute(
      name: Constants.mapRoute,
      builder: (context, args, params) => MapPage(),
    ),
    // SECTION AUTH
    SailorRoute(
      name: Constants.authRoute,
      builder: (context, args, params) => AuthPage(),
    ),
    SailorRoute(
      name: Constants.authAnonymousRoute,
      builder: (context, args, params) => SignInAnonymouslyPage(),
    ),
    SailorRoute(
      name: Constants.authSigninRoute,
      builder: (context, args, params) => SignInWithEmailPage(),
    ),
    SailorRoute(
      name: Constants.authSignupRoute,
      builder: (context, args, params) => SignUpWithEmailPage(),
    ),
    SailorRoute(
      name: Constants.authConfirmationRoute,
      builder: (context, args, params) => ConfirmationLinkSentPage(),
    ),
    SailorRoute(
      name: Constants.authTOSRoute,
      builder: (context, args, params) => TermsOfServicePage(),
    ),
    SailorRoute(
      name: Constants.authPPRoute,
      builder: (context, args, params) => PrivacyPolicyPage(),
    ),
    SailorRoute(
      name: Constants.authSigninProblemRoute,
      builder: (context, args, params) => SignInProblemPage(),
    ),
    SailorRoute(
      name: Constants.authResetPasswordRoute,
      builder: (context, args, params) => ResetPasswordLinkSentPage(),
    ),
    //SECTION PROFILE
    SailorRoute(
      name: Constants.completeProfileRoute,
      builder: (context, args, params) => CompleteProfilePage(),
    ),
    SailorRoute(
      name: Constants.profileRoute,
      builder: (context, args, params) => MyProfilePage(),
    ),
    SailorRoute(
      name: Constants.profileFollowingRoute,
      builder: (context, args, params) => MyFollowingPage(),
    ),
    SailorRoute(
      name: Constants.profileBonfiresRoute,
      builder: (context, args, params) => MyBonfiresPage(),
    ),
    SailorRoute(
      name: Constants.profileDQRoute,
      builder: (context, args, params) => MyDailyQuestPage(),
    ),
    SailorRoute(
      name: Constants.profilePenaltyRoute,
      builder: (context, args, params) => MyPenaltyPage(),
    ),
    SailorRoute(
      name: Constants.profileTrophiesRoute,
      builder: (context, args, params) => MyTrophiesPage(),
    ),
    SailorRoute(
      name: Constants.profileStoreRoute,
      builder: (context, args, params) => StorePage(),
    ),
    SailorRoute(
      name: Constants.profileStorePreviewRoute,
      builder: (context, args, params) => ItemPreviewPage(
        args: args as ItemPreviewPageArgs,
      ),
    ),
    // SECTION SEARCH
    SailorRoute(
      name: Constants.searchRoute,
      builder: (context, args, params) => SearchPage(),
    ),
    // SECTION BONFIRES
    SailorRoute(
      name: Constants.lightBonfireFileRoute,
      builder: (context, args, params) => LightBonfireFilePage(),
    ),
    SailorRoute(
      name: Constants.lightBonfireFilePreviewRoute,
      builder: (context, args, params) => LightBonfireFilePreviewPage(
        args: args as FileArgs,
      ),
    ),
    SailorRoute(
      name: Constants.lightBonfireImageRoute,
      builder: (context, args, params) => LightBonfireImagePage(),
    ),
    SailorRoute(
      name: Constants.lightBonfireImagePreviewRoute,
      builder: (context, args, params) => LightBonfireImagePreviewPage(
        args: args as FileArgs,
      ),
    ),
    SailorRoute(
      name: Constants.lightBonfireVideoRoute,
      builder: (context, args, params) => LightBonfireVideoPage(),
    ),
    SailorRoute(
      name: Constants.lightBonfireVideoPreviewRoute,
      builder: (context, args, params) => LightBonfireVideoPreviewPage(
        args: args as FileArgs,
      ),
    ),
    SailorRoute(
      name: Constants.lightBonfireTextRoute,
      builder: (context, args, params) => LightBonfireTextPage(),
    ),
    SailorRoute(
      name: Constants.bonfireRoute,
      builder: (context, args, params) => BonfirePage(
        args: args as BonfireArgs,
      ),
    ),
    SailorRoute(
      name: Constants.bonfireImageRoute,
      builder: (context, args, params) => BonfireImageViewPage(
        args: args as VisualBonfireArgs,
      ),
    ),
    SailorRoute(
      name: Constants.bonfireVideoRoute,
      builder: (context, args, params) => BonfireVideoViewPage(
        args: args as VisualBonfireArgs,
      ),
    ),
    // SECTION SETTINGS
    SailorRoute(
      name: Constants.settingsRoute,
      builder: (context, args, params) => SettingsPage(),
    ),
    SailorRoute(
      name: Constants.settingsNameRoute,
      builder: (context, args, params) => EditNamePage(),
    ),
    SailorRoute(
      name: Constants.settingsEmailRoute,
      builder: (context, args, params) => EditEmailAddressPage(),
    ),
    SailorRoute(
      name: Constants.settingsPasswordRoute,
      builder: (context, args, params) => EditPasswordPage(),
    ),
    SailorRoute(
      name: Constants.settingsPermissionsRoute,
      builder: (context, args, params) => EditPermissionsPage(),
    ),
    SailorRoute(
      name: Constants.settingsDataRoute,
      builder: (context, args, params) => MyDataPage(),
    ),
    SailorRoute(
      name: Constants.settingsReportRoute,
      builder: (context, args, params) => ReportProblemPage(),
    ),
    SailorRoute(
      name: Constants.settingsFeedbackRoute,
      builder: (context, args, params) => GiveFeedbackPage(),
    ),
  ]);
}
