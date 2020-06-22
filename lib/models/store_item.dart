import 'package:cloud_firestore/cloud_firestore.dart';

class StoreItem {
  String id;
  String translationKey;
  int price;
  String spotlightPromotionPictureUrl;
  String promotionPictureUrl;
  String description;
  List<String> previewPictureUrls;
  bool spotlight;

  StoreItem({
    this.id,
    this.translationKey,
    this.price,
    this.spotlightPromotionPictureUrl,
    this.promotionPictureUrl,
    this.description,
    this.previewPictureUrls,
    this.spotlight,
  });

  factory StoreItem.fromFirestore(DocumentSnapshot document) {
    final Map data = document.data;
    return StoreItem(
      id: data['id'] as String,
      translationKey: data['translationKey'] as String,
      price: data['price'] as int,
      spotlightPromotionPictureUrl:
          data['spotlightPromotionPictureUrl'] as String,
      promotionPictureUrl: data['promotionPictureUrl'] as String,
      description: data['description'] as String,
      previewPictureUrls: data['previewPictureUrls'] as List<String>,
      spotlight: data['spotlight'] as bool,
    );
  }

  factory StoreItem.fromMap(Map data) {
    return StoreItem(
      id: data['id'] as String,
      translationKey: data['translationKey'] as String,
      price: data['price'] as int,
      spotlightPromotionPictureUrl:
          data['spotlightPromotionPictureUrl'] as String,
      promotionPictureUrl: data['promotionPictureUrl'] as String,
      description: data['description'] as String,
      previewPictureUrls: data['previewPictureUrls'] as List<String>,
      spotlight: data['spotlight'] as bool,
    );
  }

  @override
  String toString() {
    return 'id: $id, translationKey: $translationKey, price: $price, spotlightPromotionPictureUrl: $spotlightPromotionPictureUrl, promotionPictureUrl: $promotionPictureUrl, description: $description, previewPictureUrls: $previewPictureUrls';
  }
}
