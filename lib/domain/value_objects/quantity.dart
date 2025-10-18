import '../../core/errors/failures.dart';

/// Value Object для количества с валидацией
class Quantity {
  final int value;

  const Quantity._(this.value);

  /// Создать количество с валидацией
  factory Quantity.create(int amount) {
    if (amount < 0) {
      throw ValidationFailure('Количество не может быть отрицательным');
    }

    if (amount > 1000000) {
      throw ValidationFailure('Количество слишком велико');
    }

    return Quantity._(amount);
  }

  /// Создать из строки
  factory Quantity.fromString(String input) {
    final parsed = int.tryParse(input.trim());

    if (parsed == null) {
      throw ValidationFailure('Некорректное значение количества');
    }

    return Quantity.create(parsed);
  }

  /// Создать без валидации (для существующих данных)
  factory Quantity.fromTrustedSource(int value) {
    return Quantity._(value);
  }

  /// Проверить достаточно ли количества
  bool isSufficient(int required) => value >= required;

  /// Проверить пусто ли
  bool get isEmpty => value == 0;

  /// Проверить не пусто ли
  bool get isNotEmpty => value > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quantity &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
