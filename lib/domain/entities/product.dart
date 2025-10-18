import 'package:equatable/equatable.dart';

/// Сущность товара
/// Содержит основную информацию о продукте
class ProductEntity extends Equatable {
  /// Название товара
  final String name;

  /// GTIN код (13 цифр)
  final String gtin;

  /// Активен ли товар
  final bool isActive;

  /// Цена товара
  final double price;

  /// Путь к изображению товара (локальный файл)
  final String? imagePath;

  /// Дата создания
  final DateTime createdAt;

  /// Дата последнего обновления
  final DateTime updatedAt;

  /// Дата удаления (если товар удален)
  final DateTime? deletedAt;

  const ProductEntity({
    required this.name,
    required this.gtin,
    required this.isActive,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.imagePath,
  });

  /// Создание копии с измененными полями
  ProductEntity copyWith({
    String? name,
    String? gtin,
    bool? isActive,
    double? price,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ProductEntity(
      name: name ?? this.name,
      gtin: gtin ?? this.gtin,
      isActive: isActive ?? this.isActive,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [gtin, name, price, isActive, imagePath, createdAt, updatedAt, deletedAt];
}
