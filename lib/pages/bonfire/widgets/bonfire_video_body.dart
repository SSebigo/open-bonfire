import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_description.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_video.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BonfireVideoBody extends StatefulWidget {
  final VideoBonfire _bonfire;

  const BonfireVideoBody({
    VideoBonfire bonfire,
    Key key,
  })  : _bonfire = bonfire,
        super(key: key);

  @override
  _BonfireVideoBodyState createState() => _BonfireVideoBodyState();
}

class _BonfireVideoBodyState extends State<BonfireVideoBody> {
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.network(widget._bonfire.videoUrl)
          ..initialize().then((_) {
            setState(() {});
          });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.setVolume(0.0);
    _videoPlayerController.play();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(() {});
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _navigateVideoView() {
    sailor(Constants.bonfireVideoRoute,
        args: VisualBonfireArgs(widget._bonfire));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget._bonfire.description != null &&
            widget._bonfire.description.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: BonfireDescription(description: widget._bonfire.description),
          )
        else
          Container(),
        if (_videoPlayerController.value.initialized)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: _navigateVideoView,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child:
                    BonfireVideo(videoPlayerController: _videoPlayerController),
              ),
            ),
          )
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

// class BonfireVideoBody extends StatelessWidget {
//   final VoidCallback _onPressed;
//   final VideoBonfire _bonfire;
//   final VideoPlayerController _videoPlayerController;

//   BonfireVideoBody(
//       {VoidCallback onPressed,
//       VideoBonfire bonfire,
//       VideoPlayerController videoPlayerController,
//       Key key})
//       : _videoPlayerController = videoPlayerController,
//         _onPressed = onPressed,
//         _bonfire = bonfire,
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         _bonfire.description != null && _bonfire.description.length > 0
//             ? Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: BonfireDescription(description: _bonfire.description),
//               )
//             : Container(),
//         _videoPlayerController.value.initialized
//             ? GestureDetector(
//                 onTap: _onPressed,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10.0),
//                   child: AspectRatio(
//                     aspectRatio: _videoPlayerController.value.aspectRatio,
//                     child: VideoPlayer(_videoPlayerController),
//                   ),
//                 ),
//               )
//             : Center(child: CircularProgressIndicator()),
//       ],
//     );
//   }
// }
