import 'package:bonfire/i18n.dart';
import 'package:bonfire/blocs/light_bonfire/bloc.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/bonfire_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';

class LightBonfireTextPage extends StatefulWidget {
  @override
  _LightBonfireTextPageState createState() => _LightBonfireTextPageState();
}

class _LightBonfireTextPageState extends State<LightBonfireTextPage> {
  String _text = '';

  void _onLightBonfireClicked() {
    BlocProvider.of<LightBonfireBloc>(context).add(
        OnLightBonfireTextClicked(text: _text, visibleBy: const <String>[]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: GestureDetector(
                onTap: _text.isEmpty ? null : _onLightBonfireClicked,
                child: Text(
                  I18n.of(context).buttonLight,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: _text.isEmpty == true
                          ? Colors.grey
                          : PaletteTwo.colorTwo,
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
        child: Center(
          child: BlocListener<LightBonfireBloc, LightBonfireState>(
            listener: (BuildContext context, LightBonfireState state) {
              if (state is LightingBonfire) {
                FocusScope.of(context).requestFocus(FocusNode());
                sailor.navigate(
                  Constants.mapRoute,
                  navigationType: NavigationType.pushAndRemoveUntil,
                  removeUntilPredicate: (_) => false,
                );
              }
              if (state is BonfireLit) {}
            },
            child: BlocBuilder<LightBonfireBloc, LightBonfireState>(
              builder: (context, state) {
                return Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10.0, right: 20.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: BonfireTextField(
                              hintText: I18n.of(context).textBonfirePlaceholder,
                              onChanged: (value) {
                                setState(() {
                                  _text = value;
                                });
                              },
                            ),
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
      ),
    );
  }
}
