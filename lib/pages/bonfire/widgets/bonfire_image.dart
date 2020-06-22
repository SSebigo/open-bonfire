import 'dart:math';

import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BonfireImage extends StatefulWidget {
  final VoidCallback onPressed;
  final String imageUrl;

  const BonfireImage({Key key, this.onPressed, this.imageUrl})
      : super(key: key);

  @override
  _BonfireImageState createState() => _BonfireImageState();
}

class _BonfireImageState extends State<BonfireImage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  String _penaltyUniqueName;

  @override
  void initState() {
    _penaltyUniqueName = _localStorageRepository
        ?.getPenaltyData(Constants.penaltyUniqueName) as String;
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
            cache: true,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return const Center(child: CircularProgressIndicator());
                  break;

                case LoadState.completed:
                  return GestureDetector(
                    onTap: widget.onPressed,
                    child: Container(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                          ),
                        ),
                      ),
                    ),
                  );

                case LoadState.failed:
                  return GestureDetector(
                    onTap: () {
                      state.reLoadImage();
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Text(I18n.of(context).textFailedLoadContent),
                      ],
                    ),
                  );
                  break;
              }
              return const CircularProgressIndicator();
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
            cache: true,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return const Center(child: CircularProgressIndicator());
                  break;

                case LoadState.completed:
                  return GestureDetector(
                    onTap: widget.onPressed,
                    child: Container(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                          ),
                        ),
                      ),
                    ),
                  );

                case LoadState.failed:
                  return GestureDetector(
                    onTap: () {
                      state.reLoadImage();
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Text(I18n.of(context).textFailedLoadContent),
                      ],
                    ),
                  );
                  break;
              }
              return const CircularProgressIndicator();
            },
          ),
        );
        break;
      default:
        return ExtendedImage.network(
          widget.imageUrl,
          cache: true,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return const Center(child: CircularProgressIndicator());
                break;

              case LoadState.completed:
                return GestureDetector(
                  onTap: widget.onPressed,
                  child: Container(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                        ),
                      ),
                    ),
                  ),
                );

              case LoadState.failed:
                return GestureDetector(
                  onTap: () {
                    state.reLoadImage();
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Text(I18n.of(context).textFailedLoadContent),
                    ],
                  ),
                );
                break;
            }
            return const CircularProgressIndicator();
          },
        );
    }
  }
}
