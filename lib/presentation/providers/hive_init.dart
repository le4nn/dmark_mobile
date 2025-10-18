import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/boxes.dart';
import '../../data/models/product_model.dart';
import '../../data/models/stock_model.dart';

Future<void> initHiveAndAdapters() async {
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProductModelAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(StockModelAdapter());
  await Hive.openBox<ProductModel>(BoxNames.products);
  await Hive.openBox<StockModel>(BoxNames.stocks);
}
