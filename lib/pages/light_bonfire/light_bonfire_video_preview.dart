import 'package:bonfire/i18n.dart';
import 'package:bonfire/blocs/light_bonfire/bloc.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/bonfire_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';
import 'package:video_player/video_player.dart';

class LightBonfireVideoPreviewPage extends StatefulWidget {
  final FileArgs args;

  const LightBonfireVideoPreviewPage({
    Key key,
    this.args,
  }) : super(key: key);

  @override
  _LightBonfireVideoPreviewPageState createState() =>
      _LightBonfireVideoPreviewPageState();
}

class _LightBonfireVideoPreviewPageState
    extends State<LightBonfireVideoPreviewPage> {
  VideoPlayerController _videoPlayerController;
  double _videoDuration = 0.0;
  double _currentVideoDuration = 0.0;

  String _description;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(widget.args.file)
      ..initialize().then((_) {
        setState(() {
          _videoDuration =
              _videoPlayerController.value.duration.inMilliseconds.toDouble();
        });
      });
    _videoPlayerController.addListener(() {
      setState(() {
        _currentVideoDuration =
            _videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(() {});
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _onLightBonfireClicked() {
    BlocProvider.of<LightBonfireBloc>(context).add(OnLightBonfireVideoClicked(
      file: widget.args.file,
      fileType: FileType.video,
      description: _description,
      visibleBy: const <String>[],
    ));
  }

  String _formatVideoDuration() {
    final Duration videoDuration =
        Duration(milliseconds: _videoDuration.toInt());
    final Duration currentDuration =
        Duration(milliseconds: _currentVideoDuration.toInt());

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final String twoDigitVideoMinutes =
        twoDigits(videoDuration.inMinutes.remainder(60) as int);
    final String twoDigitVideoSeconds =
        twoDigits(videoDuration.inSeconds.remainder(60) as int);

    final String twoDigitCurrentMinutes =
        twoDigits(currentDuration.inMinutes.remainder(60) as int);
    final String twoDigitCurrentSeconds =
        twoDigits(currentDuration.inSeconds.remainder(60) as int);

    return '$twoDigitCurrentMinutes:$twoDigitCurrentSeconds/$twoDigitVideoMinutes:$twoDigitVideoSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).accentColor,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Center(
              child: GestureDetector(
                onTap: _onLightBonfireClicked,
                child: Text(
                  I18n.of(context).buttonLight,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: PaletteTwo.colorTwo,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<LightBonfireBloc, LightBonfireState>(
          listener: (context, state) {
            if (state is LightingBonfire) {
              FocusScope.of(context).requestFocus(FocusNode());
              sailor.navigate(
                Constants.mapRoute,
                navigationType: NavigationType.pushAndRemoveUntil,
                removeUntilPredicate: (_) => false,
              );
            }
            if (state is BonfireLit) {
              // BlocProvider.of<MyProfileBloc>(context)..add(BonfireCountChanged());
            }
          },
          child: BlocBuilder<LightBonfireBloc, LightBonfireState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BonfireTextField(
                          hintText: I18n.of(context).textBonfirePlaceholder,
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 20.0),
                      child: Stack(
                        children: <Widget>[
                          if (_videoPlayerController.value.initialized)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: AspectRatio(
                                aspectRatio:
                                    _videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController),
                              ),
                            )
                          else
                            const CircularProgressIndicator(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 125.0,
                              child: Column(
                                children: <Widget>[
                                  Slider(
                                    value: _currentVideoDuration,
                                    max: _videoDuration,
                                    onChanged: (value) =>
                                        _videoPlayerController.seekTo(Duration(
                                            milliseconds: value.toInt())),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          _formatVideoDuration(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _videoPlayerController
                                                      .value.isPlaying
                                                  ? _videoPlayerController
                                                      .pause()
                                                  : _videoPlayerController
                                                      .play();
                                            });
                                          },
                                          icon: Icon(
                                            _videoPlayerController
                                                    .value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
