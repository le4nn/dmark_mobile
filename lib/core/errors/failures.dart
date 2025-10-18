/// Базовый класс для всех ошибок в приложении
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Ошибка валидации
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Ошибка хранилища данных
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Ошибка не найдено
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
