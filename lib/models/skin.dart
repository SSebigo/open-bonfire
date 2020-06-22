import 'package:cloud_firestore/cloud_firestore.dart';

class Skin {
  String avatarIconUrl,
      borderUrl,
      circleButtonDarkUrl,
      circleButtonLightUrl,
      dislikeIconUrl,
      fileIconViewedUrl,
      fileIconUrl,
      id,
      imageIconViewedUrl,
      imageIconUrl,
      likeIconUrl,
      penaltyIconUrl,
      questCompletedIconUrl,
      questInProgressIconUrl,
      textIconViewedUrl,
      textIconUrl,
      uniqueName,
      videoIconViewedUrl,
      videoIconUrl;

  Skin({
    this.avatarIconUrl,
    this.borderUrl,
    this.circleButtonDarkUrl,
    this.circleButtonLightUrl,
    this.dislikeIconUrl,
    this.fileIconViewedUrl,
    this.fileIconUrl,
    this.id,
    this.imageIconViewedUrl,
    this.imageIconUrl,
    this.likeIconUrl,
    this.penaltyIconUrl,
    this.questCompletedIconUrl,
    this.questInProgressIconUrl,
    this.textIconViewedUrl,
    this.textIconUrl,
    this.uniqueName,
    this.videoIconViewedUrl,
    this.videoIconUrl,
  });

  factory Skin.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return Skin(
      avatarIconUrl: data['avatarIconUrl'] as String,
      borderUrl: data['borderUrl'] as String,
      circleButtonDarkUrl: data['circleButtonDarkUrl'] as String,
      circleButtonLightUrl: data['circleButtonLightUrl'] as String,
      dislikeIconUrl: data['dislikeIconUrl'] as String,
      fileIconViewedUrl: data['fileIconViewedUrl'] as String,
      fileIconUrl: data['fileIconUrl'] as String,
      id: data['id'] as String,
      imageIconViewedUrl: data['imageIconViewedUrl'] as String,
      imageIconUrl: data['imageIconUrl'] as String,
      likeIconUrl: data['likeIconUrl'] as String,
      penaltyIconUrl: data['penaltyIconUrl'] as String,
      questCompletedIconUrl: data['questCompletedIconUrl'] as String,
      questInProgressIconUrl: data['questInProgressIconUrl'] as String,
      textIconViewedUrl: data['textIconViewedUrl'] as String,
      textIconUrl: data['textIconUrl'] as String,
      uniqueName: data['uniqueName'] as String,
      videoIconViewedUrl: data['videoIconViewedUrl'] as String,
      videoIconUrl: data['videoIconUrl'] as String,
    );
  }

  factory Skin.fromMap(Map data) {
    return Skin(
      avatarIconUrl: data['avatarIconUrl'] as String,
      borderUrl: data['borderUrl'] as String,
      circleButtonDarkUrl: data['circleButtonDarkUrl'] as String,
      circleButtonLightUrl: data['circleButtonLightUrl'] as String,
      dislikeIconUrl: data['dislikeIconUrl'] as String,
      fileIconViewedUrl: data['fileIconViewedUrl'] as String,
      fileIconUrl: data['fileIconUrl'] as String,
      id: data['id'] as String,
      imageIconViewedUrl: data['imageIconViewedUrl'] as String,
      imageIconUrl: data['imageIconUrl'] as String,
      likeIconUrl: data['likeIconUrl'] as String,
      penaltyIconUrl: data['penaltyIconUrl'] as String,
      questCompletedIconUrl: data['questCompletedIconUrl'] as String,
      questInProgressIconUrl: data['questInProgressIconUrl'] as String,
      textIconViewedUrl: data['textIconViewedUrl'] as String,
      textIconUrl: data['textIconUrl'] as String,
      uniqueName: data['uniqueName'] as String,
      videoIconViewedUrl: data['videoIconViewedUrl'] as String,
      videoIconUrl: data['videoIconUrl'] as String,
    );
  }

  Map<String, String> toMap() {
    final Map<String, String> map = <String, String>{};
    map['avatarIconUrl'] = avatarIconUrl;
    map['borderUrl'] = borderUrl;
    map['circleButtonDarkUrl'] = circleButtonDarkUrl;
    map['circleButtonLightUrl'] = circleButtonLightUrl;
    map['dislikeIconUrl'] = dislikeIconUrl;
    map['fileIconViewedUrl'] = fileIconViewedUrl;
    map['fileIconUrl'] = fileIconUrl;
    map['id'] = id;
    map['imageIconViewedUrl'] = imageIconViewedUrl;
    map['imageIconUrl'] = imageIconUrl;
    map['likeIconUrl'] = likeIconUrl;
    map['penaltyIconUrl'] = penaltyIconUrl;
    map['questCompletedIconUrl'] = questCompletedIconUrl;
    map['questInProgressIconUrl'] = questInProgressIconUrl;
    map['textIconViewedUrl'] = textIconViewedUrl;
    map['textIconUrl'] = textIconUrl;
    map['uniqueName'] = uniqueName;
    map['videoIconViewedUrl'] = videoIconViewedUrl;
    map['videoIconUrl'] = videoIconUrl;
    return map;
  }

  @override
  String toString() {
    return '''
      avatarIconUrl: $avatarIconUrl,
      borderUrl: $borderUrl,
      circleButtonDarkUrl: $circleButtonDarkUrl,
      circleButtonLightUrl: $circleButtonLightUrl,
      dislikeIconUrl: $dislikeIconUrl,
      fileIconViewedUrl: $fileIconViewedUrl,
      fileIconUrl: $fileIconUrl,
      id: $id,
      imageIconViewedUrl: $imageIconViewedUrl,
      imageIconUrl: $imageIconUrl,
      likeIconUrl: $likeIconUrl,
      penaltyIconUrl: $penaltyIconUrl,
      questCompletedIconUrl: $questCompletedIconUrl,
      questInProgressIconUrl: $questInProgressIconUrl,
      textIconViewedUrl: $textIconViewedUrl,
      textIconUrl: $textIconUrl,
      uniqueName: $uniqueName,
      videoIconViewedUrl: $videoIconViewedUrl,
      videoIconUrl: $videoIconUrl,
    ''';
  }
}
