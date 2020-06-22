import 'dart:math';

import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BonfireVideo extends StatefulWidget {
  final VideoPlayerController _videoPlayerController;

  const BonfireVideo({
    VideoPlayerController videoPlayerController,
    Key key,
  })  : _videoPlayerController = videoPlayerController,
        super(key: key);

  @override
  _BonfireVideoState createState() => _BonfireVideoState();
}

class _BonfireVideoState extends State<BonfireVideo> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  String _penaltyUniqueName;

  @override
  void initState() {
    _penaltyUniqueName = _localStorageRepository
        ?.getPenaltyData(Constants.penaltyUniqueName) as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_penaltyUniqueName) {
      case 'mirror':
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: AspectRatio(
            aspectRatio: widget._videoPlayerController.value.aspectRatio,
            child: VideoPlayer(widget._videoPlayerController),
          ),
        );
        break;
      case 'upside_down':
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(pi),
          child: AspectRatio(
            aspectRatio: widget._videoPlayerController.value.aspectRatio,
            child: VideoPlayer(widget._videoPlayerController),
          ),
        );
        break;
      default:
        return AspectRatio(
          aspectRatio: widget._videoPlayerController.value.aspectRatio,
          child: VideoPlayer(widget._videoPlayerController),
        );
    }
  }
}
