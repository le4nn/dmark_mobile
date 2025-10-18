import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/stock.dart';
import '../../domain/entities/product.dart';
import '../../core/constants/breakpoints.dart';
import '../providers/app_providers.dart';
import '../pages/add_edit_stock_page.dart';
import 'stock_card.dart';

/// Providers для StockList
final stocksProvider = FutureProvider.autoDispose<List<StockEntity>>(
  (ref) async {
    final getStockList = ref.read(getStockListProvider);
    return await getStockList();
  },
);

final productsMapProvider = FutureProvider.autoDispose<Map<String, ProductEntity>>(
  (ref) async {
    final getAllProducts = ref.read(getAllProductsProvider);
    final products = await getAllProducts();
    return {for (var p in products) p.gtin: p};
  },
);

final warehouseFilterProvider = StateProvider<String?>((ref) => null);

/// Виджет для отображения списка остатков
class StockList extends ConsumerWidget {
  const StockList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouseFilter = ref.watch(warehouseFilterProvider);
    final stocksAsync = ref.watch(stocksProvider);
    final productsAsync = ref.watch(productsMapProvider);
    final theme = Theme.of(context);

    return stocksAsync.when(
      data: (stocks) {
        // Фильтрация по складу
        final filteredStocks = warehouseFilter == null
            ? stocks
            : stocks.where((s) => s.warehouse == warehouseFilter).toList();

        if (stocks.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Нет остатков',
            message: 'Начните добавлять остатки на склады',
          );
        }

        if (filteredStocks.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.filter_list_off_rounded,
            title: 'Нет остатков',
            message: 'На выбранном складе нет остатков',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(stocksProvider);
            ref.invalidate(productsMapProvider);
          },
          child: productsAsync.when(
            data: (productsMap) {
              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: Breakpoints.paddingS,
                  bottom: 100,
                ),
                itemCount: filteredStocks.length,
                itemBuilder: (context, i) {
                  final stock = filteredStocks[i];
                  final product = productsMap[stock.productGtin];

                  return StockCard(
                    stock: stock,
                    productName: product?.name,
                    onTap: () async {
                      // Навигация на страницу редактирования
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditStockPage(
                            initialStock: stock,
                          ),
                        ),
                      );
                      // Обновляем список после возврата
                      ref.invalidate(stocksProvider);
                    },
                    onDecreaseQuantity: (amount) async {
                      // Уменьшаем количество с валидацией
                      final newQuantity = stock.quantity - amount;
                      if (newQuantity < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Нельзя отнять больше чем есть'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      try {
                        final updatedStock = StockEntity(
                          warehouse: stock.warehouse,
                          productGtin: stock.productGtin,
                          quantity: newQuantity,
                        );
                        await ref.read(upsertStockProvider)(updatedStock);
                        ref.invalidate(stocksProvider);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Отнято $amount шт. Осталось: $newQuantity шт.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.orange,
                            ));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка: $e'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ));
                        }
                      }
                    },
                    onDelete: () async {
                      final ok = await _showDeleteDialog(
                        context,
                        stock.warehouse,
                        stock.productGtin,
                      );
                      if (ok && context.mounted) {
                        await ref.read(removeStockProvider)(
                          stock.warehouse,
                          stock.productGtin,
                        );
                        ref.invalidate(stocksProvider);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Остаток удалён'),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              )));
                        }
                      }
                    });
                });
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Ошибка загрузки продуктов: $error'),
            )));
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: Breakpoints.paddingM),
            Text(
              'Загрузка остатков...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ))])),
      error: (error, stack) => _buildEmptyState(
        context,
        icon: Icons.error_outline_rounded,
        title: 'Произошла ошибка',
        message: error.toString(),
        isError: true,
      ));
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Breakpoints.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Breakpoints.paddingL),
              decoration: BoxDecoration(
                color: (isError
                        ? theme.colorScheme.errorContainer
                        : theme.colorScheme.primaryContainer)
                    .withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: isError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary)),
            const SizedBox(height: Breakpoints.paddingL),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
            const SizedBox(height: Breakpoints.paddingS),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center)])));
  }

  Future<bool> _showDeleteDialog(
    BuildContext context,
    String warehouse,
    String gtin,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.error,
            ),
            title: const Text('Удалить остаток?'),
            content: Text(
              'Остаток товара $gtin на складе "$warehouse" будет удалён без возможности восстановления',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Удалить'))])) ?? false;
  }
}
