import 'package:file_picker/file_picker.dart';

class Paths {
  // database paths
  static const String bonfiresPath = 'bonfires';
  static const String dailyQuestsPath = 'daily_quests';
  static const String penaltiesPath = 'penalties';
  static const String skinsPath = 'skins';
  static const String usernameUidMapPath = 'username_uid_map';
  static const String trophiesPath = 'trophies';
  static const String usersPath = 'users';

  // storage paths
  static const String fileAttachmentsPath = 'files';
  static const String imageAttachmentsPath = 'images';
  static const String profilePicturePath = 'profile_pictures';
  static const String videoAttachmentsPath = 'videos';

  static String getAttachmentsPathByFileType(FileType fileType) {
    if (fileType == FileType.image) {
      return imageAttachmentsPath;
    } else if (fileType == FileType.video) {
      return videoAttachmentsPath;
    } else {
      return fileAttachmentsPath;
    }
  }
}
