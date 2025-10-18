import '../../core/errors/failures.dart';

/// Value Object для цены с валидацией
class Price {
  final double value;

  const Price._(this.value);

  /// Создать цену с валидацией
  factory Price.create(double amount) {
    if (amount < 0) {
      throw ValidationFailure('Цена не может быть отрицательной');
    }

    if (amount > 1000000000) {
      throw ValidationFailure('Цена слишком велика');
    }

    // Округление до 2 знаков после запятой
    final rounded = (amount * 100).round() / 100;

    return Price._(rounded);
  }

  /// Создать из строки
  factory Price.fromString(String input) {
    final normalized = input.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);

    if (parsed == null) {
      throw ValidationFailure('Некорректное значение цены');
    }

    return Price.create(parsed);
  }

  /// Создать без валидации (для существующих данных)
  factory Price.fromTrustedSource(double value) {
    return Price._(value);
  }

  /// Форматирование для отображения
  String toDisplayString() {
    return value.toStringAsFixed(2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Price && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
