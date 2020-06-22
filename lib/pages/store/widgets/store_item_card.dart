import 'package:bonfire/models/store_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreItemCard extends StatelessWidget {
  final StoreItem _storeItem;
  final VoidCallback _onPressed;

  const StoreItemCard({
    Key key,
    StoreItem storeItem,
    VoidCallback onPressed,
  })  : _storeItem = storeItem,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              _storeItem.promotionPictureUrl,
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
                    _storeItem.price == 0
                        ? 'Gratuit'
                        : _storeItem.price.toString(),
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
