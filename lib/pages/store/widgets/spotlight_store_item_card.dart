import 'package:bonfire/models/store_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpotlightStoreItemCard extends StatelessWidget {
  final StoreItem storeItem;
  final VoidCallback onPressed;

  const SpotlightStoreItemCard({
    Key key,
    this.storeItem,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              storeItem.spotlightPromotionPictureUrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Image.asset(
                      'assets/img/gold-coin.png',
                      width: 25.0,
                    ),
                  ),
                  Text(
                    storeItem.price == 0
                        ? 'Gratuit'
                        : storeItem.price as String,
                    style: GoogleFonts.varelaRound(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
