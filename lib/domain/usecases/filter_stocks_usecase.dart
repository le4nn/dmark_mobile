import '../entities/stock.dart';

/// Use Case для фильтрации складских остатков
/// Содержит бизнес-логику фильтрации
class FilterStocksUseCase {
  /// Фильтровать по складу
  List<StockEntity> filterByWarehouse(
    List<StockEntity> stocks,
    String? warehouse,
  ) {
    if (warehouse == null || warehouse.trim().isEmpty) {
      return stocks;
    }

    final searchTerm = warehouse.trim().toLowerCase();

    return stocks.where((stock) {
      return stock.warehouse.toLowerCase().contains(searchTerm);
    }).toList();
  }

  /// Фильтровать по продукту (GTIN)
  List<StockEntity> filterByProduct(
    List<StockEntity> stocks,
    String? gtin,
  ) {
    if (gtin == null || gtin.trim().isEmpty) {
      return stocks;
    }

    return stocks.where((stock) {
      return stock.productGtin == gtin.trim();
    }).toList();
  }

  /// Фильтровать по минимальному количеству
  List<StockEntity> filterByMinQuantity(
    List<StockEntity> stocks,
    int minQuantity,
  ) {
    return stocks.where((stock) => stock.quantity >= minQuantity).toList();
  }

  /// Получить только с недостаточным количеством
  List<StockEntity> filterLowStock(
    List<StockEntity> stocks,
    int threshold,
  ) {
    return stocks.where((stock) => stock.quantity < threshold).toList();
  }

  /// Группировать по складу
  Map<String, List<StockEntity>> groupByWarehouse(List<StockEntity> stocks) {
    final Map<String, List<StockEntity>> grouped = {};

    for (final stock in stocks) {
      if (!grouped.containsKey(stock.warehouse)) {
        grouped[stock.warehouse] = [];
      }
      grouped[stock.warehouse]!.add(stock);
    }

    return grouped;
  }
}
