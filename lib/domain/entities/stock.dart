/// Сущность остатка товара на складе
/// Представляет количество конкретного товара на определенном складе
class StockEntity {
  /// Название склада
  final String warehouse;

  /// GTIN код товара
  final String productGtin;

  /// Количество товара на складе
  final int quantity;

  const StockEntity({
    required this.warehouse,
    required this.productGtin,
    required this.quantity,
  });

  /// Создание копии с измененными полями
  StockEntity copyWith({
    String? warehouse,
    String? productGtin,
    int? quantity,
  }) {
    return StockEntity(
      warehouse: warehouse ?? this.warehouse,
      productGtin: productGtin ?? this.productGtin,
      quantity: quantity ?? this.quantity,
    );
  }
}
