import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/store_item.dart';
import 'package:bonfire/pages/store/bloc/store_bloc.dart';
import 'package:bonfire/pages/store/widgets/spotlight_store_item_card.dart';
import 'package:bonfire/pages/store/widgets/store_item_card.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final List<StoreItem> storeItems = [
    StoreItem.fromMap({
      'id': 'hbbwe9f78wqe0bfq0ew78fvwef087',
      'translationKey': 'textBonfireLaunch',
      'price': 0,
      'spotlightPromotionPictureUrl': 'https://via.placeholder.com/1024x500',
      'promotionPictureUrl': 'https://via.placeholder.com/512x512',
      'description': '',
      'previewPictureUrls': <String>[],
      'spotlight': true,
    }),
    StoreItem.fromMap({
      'id': 'hbbwe9f78wqe0bfq0ew78fvwef087',
      'translationKey': 'textHalloween2020',
      'price': 350,
      'spotlightPromotionPictureUrl': 'https://via.placeholder.com/1024x500',
      'promotionPictureUrl': 'https://via.placeholder.com/512x512',
      'description': '',
      'previewPictureUrls': <String>[],
      'spotlight': false,
    }),
    StoreItem.fromMap({
      'id': 'hbbwe9f78wqe0bfq0ew78fvwef087',
      'translationKey': 'textChristmas2020',
      'price': 500,
      'spotlightPromotionPictureUrl': 'https://via.placeholder.com/1024x500',
      'promotionPictureUrl': 'https://via.placeholder.com/512x512',
      'description': '',
      'previewPictureUrls': <String>[],
      'spotlight': false,
    })
  ];

  @override
  void initState() {
    super.initState();
  }

  List<StaggeredTile> _generateStaggeredTiles() {
    final List<StaggeredTile> staggeredTiles = <StaggeredTile>[];

    storeItems.forEach((item) {
      if (item.spotlight) {
        staggeredTiles.add(const StaggeredTile.count(2, 1));
      } else {
        staggeredTiles.add(const StaggeredTile.count(1, 1));
      }
    });

    return staggeredTiles;
  }

  List<Widget> _generateTiles() {
    final List<Widget> tiles = <Widget>[];

    storeItems.forEach((item) {
      if (item.spotlight) {
        tiles.add(SpotlightStoreItemCard(
          storeItem: item,
          onPressed: () => sailor.navigate(
            Constants.profileStorePreviewRoute,
            args: ItemPreviewPageArgs(item),
          ),
        ));
      } else {
        tiles.add(StoreItemCard(
          storeItem: item,
          onPressed: () => sailor.navigate(
            Constants.profileStorePreviewRoute,
            args: ItemPreviewPageArgs(item),
          ),
        ));
      }
    });

    return tiles;
  }

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
          child: BlocBuilder<StoreBloc, StoreState>(
            builder: (context, state) {
              return StaggeredGridView.count(
                crossAxisCount: 2,
                staggeredTiles: _generateStaggeredTiles(),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: _generateTiles(),
              );
            },
          ),
        ),
      ),
    );
  }
}
