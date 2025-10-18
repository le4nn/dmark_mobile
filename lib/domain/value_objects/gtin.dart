import '../../core/errors/failures.dart';

/// Value Object для GTIN с валидацией
class Gtin {
  final String value;

  const Gtin._(this.value);

  /// Создать GTIN с валидацией
  factory Gtin.create(String input) {
    final trimmed = input.trim();
    
    // Проверка длины
    if (trimmed.length != 13) {
      throw ValidationFailure('GTIN должен содержать ровно 13 цифр');
    }

    // Проверка что только цифры
    if (!RegExp(r'^\d{13}$').hasMatch(trimmed)) {
      throw ValidationFailure('GTIN должен содержать только цифры');
    }

    // Проверка контрольной суммы (checksum)
    if (!_isValidChecksum(trimmed)) {
      throw ValidationFailure('Неверная контрольная сумма GTIN');
    }

    return Gtin._(trimmed);
  }

  /// Создать без валидации (для существующих данных)
  factory Gtin.fromTrustedSource(String value) {
    return Gtin._(value);
  }

  /// Валидация контрольной суммы GTIN-13
  static bool _isValidChecksum(String gtin) {
    if (gtin.length != 13) return false;

    int sum = 0;
    for (int i = 0; i < 12; i++) {
      final digit = int.parse(gtin[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }

    final checkDigit = (10 - (sum % 10)) % 10;
    return checkDigit == int.parse(gtin[12]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gtin && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
