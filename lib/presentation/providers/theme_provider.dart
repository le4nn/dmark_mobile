import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

import '../../core/constants/boxes.dart';

/// StateNotifier для управления темой с автоматическим сохранением
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Загрузить сохраненную тему из Hive
  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox(BoxNames.settings);
      final savedTheme = box.get(SettingsKeys.themeMode, defaultValue: 'system');
      state = _parseThemeMode(savedTheme);
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  /// Изменить тему и сохранить в Hive
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    try {
      final box = await Hive.openBox(BoxNames.settings);
      await box.put(SettingsKeys.themeMode, _themeToString(mode));
    } catch (e) {
      debugPrint('Ошибка сохранения темы: $e');
    }
  }

  /// Переключить между светлой и темной темой
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }

  /// Преобразовать строку в ThemeMode
  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Преобразовать ThemeMode в строку
  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

/// Provider для управления темой с автосохранением
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
