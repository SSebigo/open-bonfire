import 'dart:io';

import 'package:bonfire/i18n.dart';
import 'package:bonfire/blocs/light_bonfire/bloc.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/circle_button.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LightBonfireVideoPage extends StatefulWidget {
  @override
  _LightBonfireVideoPageState createState() => _LightBonfireVideoPageState();
}

class _LightBonfireVideoPageState extends State<LightBonfireVideoPage> {
  final Logger logger = Logger();

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  Map<String, dynamic> _skin;

  List<CameraDescription> _cameras;
  CameraController _cameraController;
  bool _isRecording = false;
  String _filePath = '';

  @override
  void initState() {
    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Transform.scale(
        scale: _cameraController.value.aspectRatio / size.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: _cameraController.value.aspectRatio,
            child: CameraPreview(_cameraController),
          ),
        ),
      ),
    );
  }

  Widget _buildControlView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            FontAwesome5.images,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: _showFilePicker,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: 200.0 / MediaQuery.of(context).devicePixelRatio,
            height: 200.0 / MediaQuery.of(context).devicePixelRatio,
            child: Stack(
              children: <Widget>[
                Icon(
                  _isRecording ? Icons.stop : Icons.play_arrow,
                  color: _isRecording ? PaletteTwo.colorOne : Colors.white,
                  size: 50.0,
                ),
                CircleButton(
                  onTap:
                      _isRecording ? _stopVideoRecording : _startVideoRecording,
                  width: 200.0 / MediaQuery.of(context).devicePixelRatio,
                  height: 200.0 / MediaQuery.of(context).devicePixelRatio,
                  imagePath: _skin['circleButtonLightUrl'] as String,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Feather.repeat,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: _onCameraSwitch,
        ),
      ],
    );
  }

  Future<void> _showFilePicker() async {
    final File file = await FilePicker.getFile(type: FileType.video);
    BlocProvider.of<LightBonfireBloc>(context).add(OnVideoPicked(file: file));
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    setState(() {
      _isRecording = true;
    });
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now()}.mp4';
    setState(() {
      _filePath = filePath;
    });
    if (_cameraController.value.isRecordingVideo) {
      return;
    }
    try {
      await _cameraController.startVideoRecording(filePath);
    } on CameraException catch (error) {
      Flushbar(
        title: I18n.of(context).textErrorOccured,
        message: '${I18n.of(context).textErrorRecording}: ${error.description}',
        icon: Icon(Icons.error_outline, color: Colors.redAccent),
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
        leftBarIndicatorColor: Colors.redAccent,
      ).show(context);
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return;
    }
    setState(() {
      _isRecording = false;
    });
    try {
      await _cameraController.stopVideoRecording();

      final File file = File(_filePath);
      BlocProvider.of<LightBonfireBloc>(context).add(OnVideoPicked(file: file));
    } on CameraException catch (error) {
      Flushbar(
        title: I18n.of(context).textErrorOccured,
        message: '${I18n.of(context).textErrorRecording}: ${error.description}',
        icon: Icon(Icons.error_outline, color: Colors.redAccent),
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
        leftBarIndicatorColor: Colors.redAccent,
      ).show(context);
    }
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_cameraController.description == _cameras[0])
            ? _cameras[1]
            : _cameras[0];
    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);
    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        Flushbar(
          title: I18n.of(context).textErrorOccured,
          message: _cameraController.value.errorDescription,
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.error, color: Colors.redAccent),
          flushbarStyle: FlushbarStyle.FLOATING,
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
          leftBarIndicatorColor: Colors.redAccent,
        ).show(context);
      }
    });
    try {
      await _cameraController.initialize();
    } on CameraException catch (_) {}

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController != null) {
      if (!_cameraController.value.isInitialized) {
        return Container();
      }
    } else {
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: BlocListener<LightBonfireBloc, LightBonfireState>(
          listener: (context, state) {
            if (state is DisplayVideoPreviewState) {
              sailor.navigate(
                Constants.lightBonfireVideoPreviewRoute,
                args: FileArgs(state.file),
              );
            }
            if (state is LightBonfireError) {
              Flushbar(
                title: I18n.of(context).textErrorOccured,
                message:
                    '${I18n.of(context).textErrorLightingBonfire}: ${state.error.message as String}',
                icon: Icon(Icons.error_outline, color: Colors.redAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.redAccent,
              ).show(context);
            }
          },
          child: BlocBuilder<LightBonfireBloc, LightBonfireState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  _buildCameraPreview(),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildControlView(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
