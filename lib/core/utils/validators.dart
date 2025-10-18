class Validators {
  static String? validateGtin13(String? value) {
    if (value == null || value.isEmpty) return 'GTIN обязателен';
    final trimmed = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\d{13}$').hasMatch(trimmed)) {
      return 'GTIN должен содержать ровно 13 цифр';
    }
    return null;
  }
}
