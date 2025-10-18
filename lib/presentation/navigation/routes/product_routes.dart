import 'package:go_router/go_router.dart';

import '../../pages/add_edit_product_page.dart';

/// Типизированные маршруты для модуля Products
abstract class ProductRoutes {
  // Названия маршрутов
  static const String list = 'products';
  static const String add = 'product-add';

  // Пути маршрутов
  static const String listPath = '/products';
  static const String addPath = 'add';

  /// Конфигурация маршрутов модуля Products
  static List<RouteBase> routes = [
    GoRoute(
      path: addPath,
      name: add,
      builder: (context, state) => const AddEditProductPage(),
    ),
  ];
}
