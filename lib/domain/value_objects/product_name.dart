import '../../core/errors/failures.dart';

/// Value Object для названия продукта с валидацией
class ProductName {
  final String value;

  const ProductName._(this.value);

  /// Создать название с валидацией
  factory ProductName.create(String input) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      throw ValidationFailure('Название продукта не может быть пустым');
    }

    if (trimmed.length < 2) {
      throw ValidationFailure('Название должно содержать минимум 2 символа');
    }

    if (trimmed.length > 200) {
      throw ValidationFailure('Название не может быть длиннее 200 символов');
    }

    return ProductName._(trimmed);
  }

  /// Создать без валидации (для существующих данных)
  factory ProductName.fromTrustedSource(String value) {
    return ProductName._(value);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductName &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
