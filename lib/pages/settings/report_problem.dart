import 'package:bonfire/blocs/settings/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/bonfire_text_field.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringprocess/stringprocess.dart';

class ReportProblemPage extends StatefulWidget {
  @override
  _ReportProblemPageState createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final StringProcessor _stringProcessor = StringProcessor();

  String _body = '';

  bool _isReportProblemEnabled() {
    return _stringProcessor.getWordCount(_body) >= 5;
  }

  void _reportProblem() {
    BlocProvider.of<SettingsBloc>(context)
        .add(OnReportProblemClicked(body: _body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          I18n.of(context).textReportProblem,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is ReportingProblemState) {
              Flushbar(
                message: I18n.of(context).textRetrieveDeviceData,
                icon: Icon(Icons.file_upload, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
            if (state is ProblemReportedState) {
              _body = '';
              Flushbar(
                message: I18n.of(context).textThanksReportProblem,
                icon: Icon(Icons.check_circle_outline, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.greenAccent,
              ).show(context);
            }
            if (state is SettingsFailedState) {
              Flushbar(
                title: I18n.of(context).textErrorOccured,
                message: state.error.message as String,
                icon: Icon(Icons.error_outline, color: Colors.redAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.redAccent,
              ).show(context);
            }
          },
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Text(
                      I18n.of(context).textReportProblemDisclaimer,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: BonfireTextField(
                      hintText: I18n.of(context).textReportProblemHint,
                      onChanged: (value) {
                        setState(() {
                          _body = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Button(
                      color: PaletteOne.colorOne,
                      height: 60.0,
                      text: I18n.of(context).textReportProblem,
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      width: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed:
                          _isReportProblemEnabled() ? _reportProblem : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
