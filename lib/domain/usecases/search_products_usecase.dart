import '../entities/product.dart';

/// Use Case для поиска продуктов
/// Содержит бизнес-логику поиска
class SearchProductsUseCase {
  /// Поиск продуктов по запросу
  /// 
  /// Поиск выполняется по:
  /// - Названию продукта (без учета регистра)
  /// - GTIN коду
  List<ProductEntity> call(List<ProductEntity> products, String query) {
    if (query.trim().isEmpty) {
      return products;
    }

    final searchTerm = query.trim().toLowerCase();

    return products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(searchTerm);
      final gtinMatch = product.gtin.contains(searchTerm);

      return nameMatch || gtinMatch;
    }).toList();
  }

  /// Проверить есть ли результаты поиска
  bool hasResults(List<ProductEntity> products, String query) {
    return call(products, query).isNotEmpty;
  }
}
