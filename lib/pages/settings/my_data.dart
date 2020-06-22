import 'package:bonfire/blocs/settings/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDataPage extends StatefulWidget {
  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          I18n.of(context).textMyData,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        // TODO: this part doesn't exists yet coz there's no data to download
        // TODO: but it'll be implemented later
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  I18n.of(context).textNotImplementedYet,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                    ),
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
