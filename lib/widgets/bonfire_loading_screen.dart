import 'package:flutter/material.dart';

class BonfireLoadingScreen extends StatelessWidget {
  final TickerProvider vsync;
  final bool isLoading;

  const BonfireLoadingScreen({
    Key key,
    this.vsync,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        vsync: vsync,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: isLoading ? MediaQuery.of(context).size.height : 0.0,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
