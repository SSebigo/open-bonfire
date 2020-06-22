import 'package:bonfire/models/store_item.dart';
import 'package:bonfire/services/base_service.dart';

abstract class BaseStoreService extends BaseService {
  Future<List<StoreItem>> getStoreItems();
}