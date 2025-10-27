import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../domain/usecases/sort_products_usecase.dart';
import '../../presentation/providers/app_providers.dart';
import '../../core/constants/breakpoints.dart';
import '../navigation/app_router.dart';
import '../widgets/product_list.dart';

/// Страница со списком продуктов
/// Отвечает только за структуру страницы (AppBar, поиск, FAB)
/// Отображение списка делегировано виджету ProductList
class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

/// Состояние страницы списка продуктов
class _ProductListPageState extends ConsumerState<ProductListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSortType = ref.watch(sortTypeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукты'),
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          PopupMenuButton<ProductSortType>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Сортировка',
            onSelected: (sortType) {
              ref.read(sortTypeProvider.notifier).state = sortType;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ProductSortType.byDate,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: currentSortType == ProductSortType.byDate ? theme.colorScheme.primary : null,
                    ),
                    const SizedBox(width: Breakpoints.paddingS),
                    Text(
                      'По дате',
                      style: TextStyle(
                        color: currentSortType == ProductSortType.byDate ? theme.colorScheme.primary : null,
                        fontWeight: currentSortType == ProductSortType.byDate ? FontWeight.bold : null,
                      ))])),
              PopupMenuItem(
                value: ProductSortType.byName,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha_rounded,
                      size: 20,
                      color: currentSortType == ProductSortType.byName ? theme.colorScheme.primary : null,
                    ),
                    const SizedBox(width: Breakpoints.paddingS),
                    Text(
                      'По имени',
                      style: TextStyle(
                        color: currentSortType == ProductSortType.byName ? theme.colorScheme.primary : null,
                        fontWeight: currentSortType == ProductSortType.byName ? FontWeight.bold : null,
                      ))]))]),
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded),
            tooltip: 'Сменить тему',
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            }),
          const SizedBox(width: Breakpoints.paddingS)]),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(Breakpoints.paddingM),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Breakpoints.borderRadiusL),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        })
                    : null,
                hintText: 'Поиск по названию или GTIN',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Breakpoints.paddingM,
                  vertical: Breakpoints.paddingM)),
              onChanged: (v) {
                ref.read(searchQueryProvider.notifier).state = v.trim();
                setState(() {});
              })),
          const Expanded(child: ProductList())]),
      floatingActionButton: _buildFloatingActionButtons(context));
  }

  /// Построение кнопок действий с адаптивным дизайном
  Widget _buildFloatingActionButtons(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Мобильная версия - одна кнопка с меню
        if (sizingInformation.isMobile) {
          return FloatingActionButton(
            onPressed: () => _showActionSheet(context),
            tooltip: 'Действия',
            child: const Icon(Icons.add_rounded),
          );
        }
        
        // Планшет/Десктоп - расширенные кнопки
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'stock',
              label: const Text('Склады'),
              icon: const Icon(Icons.warehouse_rounded),
              onPressed: () => AppRouter.goToStocks(context),
            ),
            const SizedBox(height: Breakpoints.paddingM),
            FloatingActionButton.extended(
              heroTag: 'add',
              label: const Text('Добавить продукт'),
              icon: const Icon(Icons.add_rounded),
              onPressed: () => AppRouter.goToAddProduct(context),
            ),
          ],
        );
      },
    );
  }

  /// Показать меню действий для мобильных устройств
  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.add_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: const Text('Добавить продукт'),
              subtitle: const Text('Создать новый продукт'),
              onTap: () {
                Navigator.pop(context);
                AppRouter.goToAddProduct(context);
              }),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(
                  Icons.warehouse_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
              title: const Text('Управление складами'),
              subtitle: const Text('Просмотр и редактирование складов'),
              onTap: () {
                Navigator.pop(context);
                AppRouter.goToStocks(context);
              }),
            const SizedBox(height: Breakpoints.paddingS)])));
  }
}
