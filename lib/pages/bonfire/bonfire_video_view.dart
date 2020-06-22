import 'package:bonfire/blocs/bonfire/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_video.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class BonfireVideoViewPage extends StatefulWidget {
  final VisualBonfireArgs args;

  const BonfireVideoViewPage({Key key, this.args}) : super(key: key);

  @override
  _BonfireVideoViewPageState createState() => _BonfireVideoViewPageState();
}

class _BonfireVideoViewPageState extends State<BonfireVideoViewPage> {
  VideoPlayerController _videoPlayerController;
  double _videoDuration = 0.0;
  double _currentVideoDuration = 0.0;

  @override
  void initState() {
    final VideoBonfire bonfire = widget.args.bonfire as VideoBonfire;

    _videoPlayerController = VideoPlayerController.network(bonfire.videoUrl)
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
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    super.dispose();
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

  void _onDownloadVideo() {
    final VideoBonfire bonfire = widget.args.bonfire as VideoBonfire;

    BlocProvider.of<BonfireBloc>(context).add(EVTOnDownloadFileClicked(
      fileUrl: bonfire.videoUrl,
      errorMessage: I18n.of(context).textErrorDownload,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocListener<BonfireBloc, BonfireState>(
          listener: (context, state) {
            if (state is STEDownloadingFile) {
              Flushbar(
                message: I18n.of(context).textDownloading,
                duration: const Duration(seconds: 3),
                icon: Icon(Icons.file_download, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
            if (state is STEFileDownloaded) {
              Flushbar(
                message: I18n.of(context).textFileDownloaded,
                duration: const Duration(seconds: 3),
                icon:
                    Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.greenAccent,
              ).show(context);
            }
            if (state is BonfireErrorState) {
              Flushbar(
                title: I18n.of(context).textErrorOccured,
                message: state.error.message as String,
                duration: const Duration(seconds: 3),
                icon: Icon(Icons.error_outline, color: Colors.redAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.redAccent,
              ).show(context);
            }
          },
          child: BlocBuilder<BonfireBloc, BonfireState>(
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onVerticalDragEnd: (_) {
                          Navigator.of(context).pop();
                        },
                        child: _videoPlayerController.value.initialized
                            ? BonfireVideo(
                                videoPlayerController: _videoPlayerController,
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 125.0,
                          color: Colors.black.withOpacity(0.75),
                          child: Column(
                            children: <Widget>[
                              Slider(
                                value: _currentVideoDuration,
                                max: _videoDuration,
                                onChanged: (value) =>
                                    _videoPlayerController.seekTo(
                                        Duration(milliseconds: value.toInt())),
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
                                          _videoPlayerController.value.isPlaying
                                              ? _videoPlayerController.pause()
                                              : _videoPlayerController.play();
                                        });
                                      },
                                      icon: Icon(
                                        _videoPlayerController.value.isPlaying
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close,
                              color: Colors.white, size: 30.0),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
                          color: Theme.of(context).primaryColor,
                          icon: Icon(Icons.more_vert,
                              color: Theme.of(context).accentColor, size: 30.0),
                          onSelected: (_) {
                            _onDownloadVideo();
                          },
                          itemBuilder: (_) => <PopupMenuItem>[
                            PopupMenuItem<String>(
                              height: 10.0,
                              enabled: true,
                              value: I18n.of(context).textSave,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.save_alt,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(
                                    I18n.of(context).textSave,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
