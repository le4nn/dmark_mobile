import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/sort_products_usecase.dart';
import '../../core/constants/breakpoints.dart';
import '../providers/app_providers.dart';
import '../pages/add_edit_product_page.dart';
import 'product_card.dart';

/// Providers для ProductList
final productsProvider = FutureProvider.autoDispose<List<ProductEntity>>(
  (ref) async {
    final getAllProducts = ref.read(getAllProductsProvider);
    return await getAllProducts();
  },
);

final searchQueryProvider = StateProvider<String>((ref) => '');
final sortTypeProvider = StateProvider<ProductSortType>((ref) => ProductSortType.byDate);

/// Виджет для отображения списка продуктов
/// Загружает продукты из репозитория, применяет поиск и сортировку
class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchQueryProvider);
    final sortType = ref.watch(sortTypeProvider);
    final productsAsync = ref.watch(productsProvider);
    final theme = Theme.of(context);

    final searchUseCase = ref.read(searchProductsProvider);
    final sortUseCase = ref.read(sortProductsProvider);

    return productsAsync.when(
      data: (products) {
        var processedProducts = products;
        processedProducts = sortUseCase(processedProducts, sortType);
        final filteredProducts = searchUseCase(processedProducts, search);

        if (products.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Нет продуктов',
            message: 'Начните добавлять продукты, нажав кнопку ниже',
          );
        }

        if (filteredProducts.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.search_off_rounded,
            title: 'Ничего не найдено',
            message: 'Попробуйте изменить поисковый запрос',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(productsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: Breakpoints.paddingS,
              bottom: 100,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, i) {
              final p = filteredProducts[i];
              return ProductCard(
                product: p,
                onDelete: () async {
                  final ok = await _showDeleteDialog(context, p.gtin);
                  if (ok && context.mounted) {
                    await ref.read(deleteProductProvider)(p.gtin);
                    ref.invalidate(productsProvider);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Продукт удалён'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          )),
                      );
                    }
                  }
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEditProductPage(),
                      settings: RouteSettings(arguments: p),
                    ),
                  );
                });
            }));
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: Breakpoints.paddingM),
            Text(
              'Загрузка продуктов...',
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

  /// Построение пустого состояния списка
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
                    : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: Breakpoints.paddingL),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Breakpoints.paddingS),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            )])));
  }

  /// Показать диалог подтверждения удаления товара
  Future<bool> _showDeleteDialog(BuildContext context, String gtin) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.error,
            ),
            title: const Text('Удалить продукт?'),
            content: Text('Продукт с GTIN $gtin будет удалён без возможности восстановления'),
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
                child: const Text('Удалить'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
