import 'package:hive/hive.dart';

import '../../../core/constants/boxes.dart';
import '../../models/product_model.dart';
import '../../models/stock_model.dart';

// Simple Hive datasource to handle Product and Stock persistence
class HiveDataSource {
  Future<Box<ProductModel>> _productsBox() async =>
      Hive.openBox<ProductModel>(BoxNames.products);
  Future<Box<StockModel>> _stocksBox() async =>
      Hive.openBox<StockModel>(BoxNames.stocks);

  // Products
  Future<void> upsertProduct(ProductModel model) async {
    final box = await _productsBox();
    await box.put(model.gtin, model);
  }

  Future<void> deleteProduct(String gtin) async {
    final box = await _productsBox();
    await box.delete(gtin);
  }

  Future<ProductModel?> getProduct(String gtin) async {
    final box = await _productsBox();
    return box.get(gtin);
  }

  Future<List<ProductModel>> getAllProducts() async {
    final box = await _productsBox();
    return box.values.toList(growable: false);
  }

  // Stocks
  String _stockKey(String warehouse, String gtin) => '${warehouse}__${gtin}';

  Future<void> upsertStock(StockModel model) async {
    final box = await _stocksBox();
    await box.put(_stockKey(model.warehouse, model.productGtin), model);
  }

  Future<StockModel?> getStock(String warehouse, String gtin) async {
    final box = await _stocksBox();
    return box.get(_stockKey(warehouse, gtin));
  }

  Future<void> deleteStock(String warehouse, String gtin) async {
    final box = await _stocksBox();
    await box.delete(_stockKey(warehouse, gtin));
  }

  Future<List<StockModel>> getAllStocks() async {
    final box = await _stocksBox();
    return box.values.toList(growable: false);
  }
}
