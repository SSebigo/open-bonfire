import 'dart:io';

import 'package:bonfire/i18n.dart';
import 'package:bonfire/blocs/light_bonfire/bloc.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:sailor/sailor.dart';

class LightBonfireFilePage extends StatefulWidget {
  @override
  _LightBonfireFilePageState createState() => _LightBonfireFilePageState();
}

class _LightBonfireFilePageState extends State<LightBonfireFilePage> {
  final Logger logger = Logger();

  Future<void> _showFilePicker() async {
    final String filePath = await FilePicker.getFilePath(type: FileType.any);
    if (filePath != null) {
      final String fileType = lookupMimeType(filePath)?.split('/')?.first;
      final File file = File(filePath);
      if (fileType == 'image') {
        BlocProvider.of<LightBonfireBloc>(context)
            .add(OnImagePicked(file: file));
      } else if (fileType == 'video') {
        BlocProvider.of<LightBonfireBloc>(context)
            .add(OnVideoPicked(file: file));
      } else {
        BlocProvider.of<LightBonfireBloc>(context)
            .add(OnFilePicked(file: file));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: BlocListener<LightBonfireBloc, LightBonfireState>(
          listener: (context, state) {
            if (state is DisplayFilePreviewState) {
              sailor.navigate(
                Constants.lightBonfireFilePreviewRoute,
                args: FileArgs(state.file),
              );
            }
            if (state is DisplayImagePreviewState) {
              sailor.navigate(
                Constants.lightBonfireImagePreviewRoute,
                args: FileArgs(state.file),
              );
            }
            if (state is DisplayVideoPreviewState) {
              sailor.navigate(
                Constants.lightBonfireVideoPreviewRoute,
                args: FileArgs(state.file),
              );
            }
          },
          child: BlocBuilder<LightBonfireBloc, LightBonfireState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: MaterialButton(
                        onPressed: _showFilePicker,
                        color: Theme.of(context).primaryColor,
                        minWidth: double.infinity,
                        height: 50.0,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          I18n.of(context).buttonSelectFile,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    )
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
