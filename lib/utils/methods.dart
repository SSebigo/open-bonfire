import 'dart:math';
import 'package:bonfire/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

/*
  Supporting only for android for now
   */
Future<String> downloadFile(
  String fileUrl, {
  String savedDir,
}) async {
  final String dirPath =
      savedDir ?? (await DownloadsPathProvider.downloadsDirectory).path;

  return FlutterDownloader.enqueue(
    url: fileUrl,
    savedDir: dirPath,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
  );
}

int nextLevel(int level) {
  return (Constants.baseXp * pow(level, Constants.exponent)).floor();
}

int nextQuestBonfireToLitAndExperience(int level) {
  return (Constants.baseQuestBonfireCount * pow(level, Constants.exponent))
      .floor();
}
