import '../entities/stock.dart';

/// Репозиторий для работы со складскими остатками
/// Отвечает ТОЛЬКО за доступ к данным, без бизнес-логики
abstract class StockRepository {
  /// Добавить или обновить остаток на складе
  /// Если остаток существует - заменяет количество, если нет - создает новый
  Future<void> upsert(StockEntity stock);

  /// Удалить остаток или уменьшить количество
  /// Если quantity == null или >= текущему - удаляет остаток полностью
  /// Если quantity < текущему - уменьшает на указанное количество
  Future<void> remove(String warehouse, String gtin, {int? quantity});

  /// Получить остаток по складу и товару
  Future<StockEntity?> get(String warehouse, String gtin);

  /// Получить все остатки (опционально фильтровать по складу)
  Future<List<StockEntity>> getAll({String? warehouse});
}
