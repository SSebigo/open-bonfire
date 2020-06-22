import 'package:bonfire/i18n.dart';
import 'package:bonfire/pages/store/bloc/store_bloc.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemPreviewPage extends StatefulWidget {
  final ItemPreviewPageArgs args;

  const ItemPreviewPage({Key key, this.args}) : super(key: key);

  @override
  _ItemPreviewPageState createState() => _ItemPreviewPageState();
}

class _ItemPreviewPageState extends State<ItemPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          I18n.of(context).textStore,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<StoreBloc, StoreState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: Container(),
        ),
      ),
    );
  }
}
