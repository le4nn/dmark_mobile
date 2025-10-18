import '../entities/product.dart';

/// Репозиторий для работы с продуктами
/// Отвечает ТОЛЬКО за доступ к данным, без бизнес-логики
abstract class ProductRepository {
  /// Добавить новый продукт
  Future<void> add(ProductEntity product);

  /// Обновить существующий продукт
  Future<void> update(ProductEntity product);

  /// Удалить продукт по GTIN
  Future<void> delete(String gtin);

  /// Получить продукт по GTIN
  Future<ProductEntity?> getByGtin(String gtin);

  /// Получить все продукты
  Future<List<ProductEntity>> getAll();
}
