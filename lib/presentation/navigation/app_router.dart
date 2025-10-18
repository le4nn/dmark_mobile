import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/product_list_page.dart';
import '../pages/stock_list_page.dart';
import 'shell_navigation.dart';
import 'routes/product_routes.dart';
import 'routes/stock_routes.dart';

/// Конфигурация навигации приложения
/// Использует GoRouter с типизированными маршрутами и ShellRoute
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  // Закэшированный экземпляр роутера
  static final GoRouter _router = _createRouter();

  /// Получение экземпляра GoRouter (закэшированный)
  static GoRouter get router => _router;

  /// Создание экземпляра GoRouter
  static GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: ProductRoutes.listPath,
      debugLogDiagnostics: false,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ShellNavigationScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: ProductRoutes.listPath,
                  name: ProductRoutes.list,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ProductListPage(),
                  ),
                  routes: ProductRoutes.routes)]),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: StockRoutes.listPath,
                  name: StockRoutes.list,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: StockListPage()),
                  routes: StockRoutes.routes)])])]);
  }

  /// Навигационные хелперы для типобезопасной навигации
  
  /// Переход к списку товаров
  static void goToProducts(BuildContext context) {
    context.goNamed(ProductRoutes.list);
  }

  /// Переход к добавлению товара
  static void goToAddProduct(BuildContext context) {
    context.goNamed(ProductRoutes.add);
  }

  /// Переход к списку складов
  static void goToStocks(BuildContext context) {
    context.goNamed(StockRoutes.list);
  }

  /// Переход к добавлению остатка
  static void goToAddStock(BuildContext context) {
    context.goNamed(StockRoutes.add);
  }
}
