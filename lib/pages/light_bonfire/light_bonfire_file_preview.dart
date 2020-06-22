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

class LightBonfireFilePreviewPage extends StatefulWidget {
  final FileArgs args;

  const LightBonfireFilePreviewPage({
    Key key,
    this.args,
  }) : super(key: key);

  @override
  _LightBonfireFilePreviewPageState createState() =>
      _LightBonfireFilePreviewPageState();
}

class _LightBonfireFilePreviewPageState
    extends State<LightBonfireFilePreviewPage> {
  String _description;

  void _onLightBonfireClicked() {
    BlocProvider.of<LightBonfireBloc>(context).add(OnLightBonfireFileClicked(
      file: widget.args.file,
      fileType: FileType.any,
      fileName: widget.args.file.path.split('/').last,
      description: _description,
      visibleBy: const <String>[],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(I18n.of(context).textFiles),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
          )
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
        child: SingleChildScrollView(
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
              ListTile(
                leading: Icon(
                  Icons.insert_drive_file,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  widget.args.file.path.split('/').last,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
