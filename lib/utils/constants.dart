class Constants {
  // User
  static const String sessionBonfireCount = 'sessionBonfireCount';
  static const String sessionCountry = 'sessionCountry';
  static const String sessionCreatedAt = 'sessionCreatedAt';
  static const String sessionDailyQuest = 'sessionDailyQuest';
  static const String sessionDayFileBonfireCount = 'sessionDayFileBonfireCount';
  static const String sessionDayImageBonfireCount =
      'sessionDayImageBonfireCount';
  static const String sessionDayTextBonfireCount = 'sessionDayTextBonfireCount';
  static const String sessionDayVideoBonfireCount =
      'sessionDayVideoBonfireCount';
  static const String sessionEmail = 'sessionEmail';
  static const String sessionExperience = 'sessionExperience';
  static const String sessionFileBonfireCount = 'sessionFileBonfireCount';
  static const String sessionFollowing = 'sessionFollowing';
  static const String sessionImageBonfireCount = 'sessionImageBonfireCount';
  static const String sessionIsAnonymous = 'sessionIsAnonymous';
  static const String sessionLevel = 'sessionsLevel';
  static const String sessionMissingTrophies = 'sessionMissingTrophies';
  static const String sessionName = 'sessionName';
  static const String sessionNextLevelExperience = 'sessionNextLevelExperience';
  static const String sessionPassword = 'sessionPassword'; // not  saved online
  static const String sessionPenalty = 'sessionPenalty';
  static const String sessionProfilePictureUrl = 'sessionProfilePictureUrl';
  static const String sessionSkinUniqueName = 'sessionSkinUniqueName';
  static const String sessionTextBonfireCount = 'sessionTextBonfireCount';
  static const String sessionTrophies = 'sessionTrophies';
  static const String sessionUid = 'sessionUid';
  static const String sessionUpdatedAt = 'sessionUpdatedAt';
  static const String sessionUpdateUserExperience =
      'sessionUpdateUserExperience'; // not saved online
  static const String sessionUpdateUserLevel =
      'sessionUpdateUserLevel'; //not saved online
  static const String sessionUsername = 'sessionUsername';
  static const String sessionVideoBonfireCount = 'sessionVideoBonfireCount';

  // Daily Quest
  static const String dailyQuestBonfireToLit = 'dailyQuestBonfireToLit';
  static const String dailyQuestCompleted = 'dailyQuestCompleted';
  static const String dailyQuestDeadline = 'dailyQuestDeadline';
  static const String dailyQuestDescription = 'dailyQuestDescription';
  static const String dailyQuestExperience = 'dailyQuestExperience';
  static const String dailyQuestPreviousDailyQuestId =
      'dailyQuestPreviousDailyQuestId';
  static const String dailyQuestProgressive = 'dailyQuestProgressive';
  static const String dailyQuestTitle = 'dailyQuestTitle';
  static const String dailyQuestId = 'dailyQuestId';
  static const String dailyQuestUniqueName = 'dailyQuestUniqueName';

  // Penalty
  static const String penaltyDeadline = 'penaltyDeadline';
  static const String penaltyDescription = 'penaltyDescription';
  static const String penaltyPreviousPenaltyId = 'penaltyPreviousPenaltyId';
  static const String penaltyTitle = 'penaltyTitle';
  static const String penaltyId = 'penaltyId';
  static const String penaltyUniqueName = 'penaltyUniqueName';

  // Config
  static const String configDarkMode = 'configDarkMode';
  static const String configFirstRun = 'configFirstRun';
  static const String configImageCompression = 'configImageCompression';
  static const String configLocale = 'configLocale';

  // user level & experience
  static const double exponent = 1.5;
  static const int baseXp = 10;
  static const int baseQuestBonfireCount = 1;

  // background tasks
  static const String updateDailyQuestOrPenalty = 'updateDailyQuestOrPenalty';

  // skins
  static const String skin = 'skin';

  // trophies
  static const String trophies = 'trophies';

  // routes
  static const String splashRoute = '/splash';
  static const String mapRoute = '/map';
  // SECTION routes auth
  static const String authRoute = '/auth';
  static const String authAnonymousRoute = '/auth/anonymously';
  static const String authSigninRoute = '/auth/sign-in-with-email';
  static const String authSignupRoute = '/auth/sign-up-with-email';
  static const String authConfirmationRoute = '/auth/confirmation-link-sent';
  static const String authTOSRoute = '/auth/terms-of-services';
  static const String authPPRoute = '/auth/privacy-policy';
  static const String authSigninProblemRoute = '/auth/signin-problem';
  static const String authResetPasswordRoute = '/auth/reset-password-link-sent';
  // SECTION routes profile
  static const String completeProfileRoute = '/complete-profile';
  static const String profileRoute = '/my-profile';
  static const String profileFollowingRoute = '/my-profile/my-following';
  static const String profileBonfiresRoute = '/my-profile/my-bonfires';
  static const String profileDQRoute = '/my-profile/my-daily-quest';
  static const String profilePenaltyRoute = '/my-profile/my-penalty';
  static const String profileTrophiesRoute = '/my-profile/my-trophies';
  static const String profileStoreRoute = '/store';
  static const String profileStorePreviewRoute = '/store/item-preview';
  // SECTION SEARCH
  static const String searchRoute = '/search';
  // SECTION BONFIRES
  static const String lightBonfireFileRoute = '/light-bonfire-file';
  static const String lightBonfireFilePreviewRoute = '/light-bonfire-file-preview';
  static const String lightBonfireImageRoute = '/light-bonfire-image';
  static const String lightBonfireImagePreviewRoute = '/light-bonfire-image-preview';
  static const String lightBonfireVideoRoute = '/light-bonfire-video';
  static const String lightBonfireVideoPreviewRoute = '/light-bonfire-video-preview';
  static const String lightBonfireTextRoute = '/light-bonfire-text';
  static const String bonfireRoute = '/bonfire';
  static const String bonfireImageRoute = '/bonfire-image-view';
  static const String bonfireVideoRoute = '/bonfire-video-view';
  // SECTION SETTINGS
  static const String settingsRoute = '/settings';
  static const String settingsNameRoute = '/settings/edit-name';
  static const String settingsEmailRoute = '/settings/edit-email-address';
  static const String settingsPasswordRoute = '/settings/edit-password';
  static const String settingsPermissionsRoute = '/settings/edit-permissions';
  static const String settingsDataRoute = '/settings/my-data';
  static const String settingsReportRoute = '/settings/report-problem';
  static const String settingsFeedbackRoute = '/settings/give-feedback';
}
