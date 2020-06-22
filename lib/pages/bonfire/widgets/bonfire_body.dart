import 'package:bonfire/blocs/bonfire/bonfire_bloc.dart';
import 'package:bonfire/blocs/bonfire/bonfire_event.dart';
import 'package:bonfire/blocs/bonfire/bonfire_state.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_file_body.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_image_body.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_text_body.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_video_body.dart';
import 'package:bonfire/widgets/bonfire_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonfireBody extends StatefulWidget {
  final Bonfire _bonfire;
  final BonfireState _state;

  const BonfireBody({Bonfire bonfire, BonfireState state, Key key})
      : _bonfire = bonfire,
        _state = state,
        super(key: key);

  @override
  _BonfireBodyState createState() => _BonfireBodyState();
}

class _BonfireBodyState extends State<BonfireBody> {
  void _showDownloadDialog(String fileUrl, String fileName) {
    showDialog(
      context: context,
      builder: (_) => BonfireDialog(
        title:
            '${I18n.of(context).buttonDownloadFile} $fileName${I18n.of(context).textQuestionMark}',
        titleButton1: I18n.of(context).buttonCancel,
        onPressedButton1: () {
          Navigator.of(context).pop();
        },
        titleButton2: I18n.of(context).buttonDownload,
        onPressedButton2: () {
          BlocProvider.of<BonfireBloc>(context).add(EVTOnDownloadFileClicked(
              fileUrl: fileUrl,
              errorMessage: I18n.of(context).textErrorDownload));
        },
        width: 300.0,
        height: 200.0,
      ),
    );
  }

  Future<void> _navigatoImageView(ImageBonfire bonfire) async {
    BlocProvider.of<BonfireBloc>(context)
        .add(EVTOnNavigateClicked(bonfire: bonfire));
  }

  @override
  Widget build(BuildContext context) {
    if (widget._bonfire is FileBonfire) {
      final FileBonfire fileBonfire = widget._bonfire as FileBonfire;
      return BonfireFileBody(
        bonfire: widget._bonfire as FileBonfire,
        onLongPress: () =>
            _showDownloadDialog(fileBonfire.fileUrl, fileBonfire.fileName),
      );
    } else if (widget._bonfire is ImageBonfire) {
      final ImageBonfire imageBonfire = widget._bonfire as ImageBonfire;
      return BonfireImageBody(
        bonfire: imageBonfire,
        onPressed: () => _navigatoImageView(imageBonfire),
        loading: widget._state is STENavigating
            ? const CircularProgressIndicator()
            : Container(),
      );
    } else if (widget._bonfire is TextBonfire) {
      return BonfireTextBody(
        bonfire: widget._bonfire as TextBonfire,
      );
    } else if (widget._bonfire is VideoBonfire) {
      return BonfireVideoBody(
        bonfire: widget._bonfire as VideoBonfire,
      );
    }
    return Container();
  }
}
