import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/hive/hive_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/stock_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/usecases/product/product_usecases.dart';
import '../../domain/usecases/stock/stock_usecases.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../../domain/usecases/sort_products_usecase.dart';
import '../../domain/usecases/filter_stocks_usecase.dart';

// Theme provider экспортируется из theme_provider.dart
export 'theme_provider.dart';

/// Провайдер данных для хранилища
final hiveDataSourceProvider = Provider<HiveDataSource>(
  (ref) => HiveDataSource(),
);

/// Провайдер репозитория для продуктов
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.read(hiveDataSourceProvider)),
);

/// Провайдер репозитория для складов
final stockRepositoryProvider = Provider<StockRepository>(
  (ref) => StockRepositoryImpl(ref.read(hiveDataSourceProvider)),
);

// Use cases - Product
/// Провайдер для добавления продукта
final addProductProvider = Provider(
  (ref) => AddProduct(ref.read(productRepositoryProvider)),
);

/// Провайдер для обновления продукта
final updateProductProvider = Provider(
  (ref) => UpdateProduct(ref.read(productRepositoryProvider)),
);

/// Провайдер для удаления продукта
final deleteProductProvider = Provider(
  (ref) => DeleteProduct(ref.read(productRepositoryProvider)),
);

/// Провайдер для получения всех продуктов
final getAllProductsProvider = Provider(
  (ref) => GetAllProducts(ref.read(productRepositoryProvider)),
);

/// Провайдер для получения продукта по GTIN
final getProductByGtinProvider = Provider(
  (ref) => GetProductByGtin(ref.read(productRepositoryProvider)),
);

// Use cases - Stock
/// Провайдер для добавления/обновления склада
final upsertStockProvider = Provider(
  (ref) => UpsertStock(ref.read(stockRepositoryProvider)),
);

/// Провайдер для удаления склада
final removeStockProvider = Provider(
  (ref) => RemoveStock(ref.read(stockRepositoryProvider)),
);

/// Провайдер для получения списка складов
final getStockListProvider = Provider(
  (ref) => GetStockList(ref.read(stockRepositoryProvider)),
);

/// Провайдер для поиска продуктов
final searchProductsProvider = Provider(
  (ref) => SearchProductsUseCase(),
);

/// Провайдер для сортировки продуктов
final sortProductsProvider = Provider(
  (ref) => SortProductsUseCase(),
);

/// Провайдер для фильтрации складов
final filterStocksProvider = Provider(
  (ref) => FilterStocksUseCase(),
);
