import 'package:bonfire/blocs/settings/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPermissionsPage extends StatefulWidget {
  @override
  _EditPermissionsPageState createState() => _EditPermissionsPageState();
}

class _EditPermissionsPageState extends State<EditPermissionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SwitchListTile(
                      title: Text(
                        'Localisation',
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      value: false,
                      onChanged: (nV) {},
                    ),
                    SwitchListTile(
                      title: Text(
                        'Camera',
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      value: false,
                      onChanged: (nV) {},
                    ),
                    SwitchListTile(
                      title: Text(
                        'Microphone',
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      value: false,
                      onChanged: (nV) {},
                    ),
                    SwitchListTile(
                      title: Text(
                        'Stockage',
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      value: false,
                      onChanged: (nV) {},
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
