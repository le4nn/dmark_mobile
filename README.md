# DMark Mobile Internship - Warehouse Management App

Мобильное приложение для управления складским инвентарем.

## 📋 Что реализовано

**Архитектура:**
- Clean Architecture (Domain, Data, Presentation)
- Riverpod для управления состоянием
- Hive для локального хранилища
- Go Router для навигации

**Функциональность:**
- CRUD операции для продуктов
- Добавление изображений (image_picker)
- Адаптивный дизайн

**Исправленные проблемы:**
- Конвертация Gradle из Kotlin DSL в Groovy
- Удаление устаревшего Android v1 embedding
- Исправление эмулятора Android

## 🚀 Быстрый старт

### 1. Установка

```bash
# Клонировать репозиторий
git clone https://github.com/le4nn/dmark_mobile.git
cd dmark_mobile_intership

# Установить зависимости
flutter pub get

# Сгенерировать Hive адаптеры
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 2. Запуск

```bash
# Запустить приложение
flutter run

# Или выбрать конкретное устройство
flutter run -d <device_id>
```

## 📦 Основные технологии

- **State Management:** Riverpod 3.0.3
- **Navigation:** Go Router 16.2.5
- **Database:** Hive 2.2.3

## 🔧 Полезные команды

```bash
# Очистка проекта
flutter clean && flutter pub get

# Hot reload в процессе разработки
r - быстрая перезагрузка
R - полный перезапуск
q - выход

# Генерация кода
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📁 Структура проекта

```
lib/
├── core/           # Общие утилиты
├── data/           # Источники данных, модели
├── domain/         # Бизнес-логика, entities
└── presentation/   # UI, страницы, виджеты
```

## ⚙️ Требования

- Flutter SDK ^3.7.2
- Dart SDK ^3.7.2
- Android Studio / VS Code
- Android SDK (API 21+) или iOS (12+)
