import 'dart:math' show pi;

import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BonfireImageAlternative extends StatefulWidget {
  final String imageUrl;

  const BonfireImageAlternative({Key key, this.imageUrl}) : super(key: key);

  @override
  _BonfireImageAlternativeState createState() =>
      _BonfireImageAlternativeState();
}

class _BonfireImageAlternativeState extends State<BonfireImageAlternative> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  String _penaltyUniqueName;

  @override
  void initState() {
    _penaltyUniqueName =
        _localStorageRepository?.getPenaltyData(Constants.penaltyUniqueName) as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_penaltyUniqueName) {
      case 'mirror':
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: ExtendedImage.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          ),
        );
        break;
      case 'upside_down':
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(pi),
          child: ExtendedImage.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          ),
        );
        break;
      default:
        return ExtendedImage.network(
          widget.imageUrl,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: false,
              initialAlignment: InitialAlignment.center,
            );
          },
        );
    }
  }
}
