import 'package:go_router/go_router.dart';

import '../../pages/add_edit_stock_page.dart';

/// Типизированные маршруты для модуля Stock
abstract class StockRoutes {
  // Названия маршрутов
  static const String list = 'stocks';
  static const String add = 'stock-add';

  // Пути маршрутов
  static const String listPath = '/stocks';
  static const String addPath = 'add';

  /// Конфигурация маршрутов модуля Stock
  static List<RouteBase> routes = [
    GoRoute(
      path: addPath,
      name: add,
      builder: (context, state) => const AddEditStockPage(),
    ),
  ];
}
