import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'presentation/navigation/app_router.dart';
import 'presentation/providers/app_providers.dart';
import 'presentation/providers/hive_init.dart';

/// Точка входа в приложение
/// Инициализирует Hive для локального хранения данных и запускает приложение
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Hive
  await Hive.initFlutter();
  await initHiveAndAdapters();
  
  runApp(const ProviderScope(child: InventoryApp()));
}

/// Главный виджет приложения
/// Настраивает тему, роутинг и провайдеры состояния
class InventoryApp extends ConsumerWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      
      // Theme configuration
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      
      // Router configuration
      routerConfig: AppRouter.router,
    );
  }
}
