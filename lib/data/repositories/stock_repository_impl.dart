import '../../domain/entities/stock.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/hive/hive_datasource.dart';
import '../models/stock_model.dart';

class StockRepositoryImpl implements StockRepository {
  final HiveDataSource dataSource;
  StockRepositoryImpl(this.dataSource);

  @override
  Future<StockEntity?> get(String warehouse, String gtin) async {
    final m = await dataSource.getStock(warehouse, gtin);
    return m?.toEntity();
  }

  @override
  Future<List<StockEntity>> getAll({String? warehouse}) async {
    final items = await dataSource.getAllStocks();
    final list = items.map((e) => e.toEntity()).toList();
    if (warehouse != null && warehouse.isNotEmpty) {
      return list.where((e) => e.warehouse == warehouse).toList();
    }
    return list;
  }

  @override
  Future<void> remove(String warehouse, String gtin, {int? quantity}) async {
    final current = await dataSource.getStock(warehouse, gtin);
    if (current == null) return;
    if (quantity == null || quantity >= current.quantity) {
      await dataSource.deleteStock(warehouse, gtin);
    } else {
      final updated = StockModel(
        warehouse: warehouse,
        productGtin: gtin,
        quantity: current.quantity - quantity,
      );
      await dataSource.upsertStock(updated);
    }
  }

  @override
  Future<void> upsert(StockEntity stock) async {
    final model = StockModel(
      warehouse: stock.warehouse,
      productGtin: stock.productGtin,
      quantity: stock.quantity,
    );
    await dataSource.upsertStock(model);
  }
}
