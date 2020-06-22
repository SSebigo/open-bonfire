import 'package:bonfire/blocs/bonfire/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_image_alternative.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/color_manipulation.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonfireImageViewPage extends StatefulWidget {
  final VisualBonfireArgs args;

  const BonfireImageViewPage({Key key, this.args}) : super(key: key);

  @override
  _BonfireImageViewPageState createState() => _BonfireImageViewPageState();
}

class _BonfireImageViewPageState extends State<BonfireImageViewPage> {
  ColorManipulation _colorManipulation;

  @override
  void initState() {
    _colorManipulation = ColorManipulation(widget.args.color);
    super.initState();
  }

  void _onDownloadImage() {
    final ImageBonfire bonfire = widget.args.bonfire as ImageBonfire;

    BlocProvider.of<BonfireBloc>(context).add(EVTOnDownloadFileClicked(
      fileUrl: bonfire.imageUrl,
      errorMessage: I18n.of(context).textErrorDownload,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ImageBonfire bonfire = widget.args.bonfire as ImageBonfire;

    return Scaffold(
      backgroundColor: widget.args.color,
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
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onVerticalDragEnd: (details) {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: double.infinity,
                      child:
                          BonfireImageAlternative(imageUrl: bonfire.imageUrl),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: _colorManipulation.isDark()
                              ? Colors.white
                              : Colors.black,
                          size: 30.0,
                        )),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      color: widget.args.color,
                      icon: Icon(Icons.more_vert,
                          color: _colorManipulation.isDark()
                              ? Colors.white
                              : Colors.black,
                          size: 30.0),
                      onSelected: (_) {
                        _onDownloadImage();
                      },
                      itemBuilder: (_) => <PopupMenuItem>[
                        PopupMenuItem<String>(
                          height: 10.0,
                          enabled: true,
                          value: I18n.of(context).textSave,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                Icons.save_alt,
                                color: _colorManipulation.isDark()
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Text(
                                I18n.of(context).textSave,
                                style: TextStyle(
                                  color: _colorManipulation.isDark()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
