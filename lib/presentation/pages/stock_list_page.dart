import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/breakpoints.dart';
import '../navigation/app_router.dart';
import '../widgets/stock_list.dart';

/// Страница со списком остатков на складах
/// Отвечает только за структуру страницы (AppBar, фильтры, FAB)
/// Отображение списка делегировано виджету StockList
class StockListPage extends ConsumerStatefulWidget {
  const StockListPage({super.key});

  @override
  ConsumerState<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends ConsumerState<StockListPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentFilter = ref.watch(warehouseFilterProvider);

    // Получаем список уникальных складов
    final stocksAsync = ref.watch(stocksProvider);
    final warehouses = stocksAsync.maybeWhen(
      data: (stocks) {
        final uniqueWarehouses = stocks.map((s) => s.warehouse).toSet().toList();
        uniqueWarehouses.sort();
        return uniqueWarehouses;
      },
      orElse: () => <String>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Склады'),
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Назад',
          onPressed: () => AppRouter.goToProducts(context),
        ),
        actions: [
          // Фильтр по складу
          if (warehouses.isNotEmpty)
            PopupMenuButton<String?>(
              icon: Badge(
                isLabelVisible: currentFilter != null,
                child: const Icon(Icons.filter_list_rounded),
              ),
              tooltip: 'Фильтр по складу',
              onSelected: (value) {
                ref.read(warehouseFilterProvider.notifier).state = value;
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: null,
                  child: Row(
                    children: [
                      Icon(
                        Icons.clear_all_rounded,
                        size: 20,
                        color: currentFilter == null
                            ? theme.colorScheme.primary
                            : null,
                      ),
                      const SizedBox(width: Breakpoints.paddingS),
                      Text(
                        'Все склады',
                        style: TextStyle(
                          color: currentFilter == null
                              ? theme.colorScheme.primary
                              : null,
                          fontWeight: currentFilter == null
                              ? FontWeight.bold
                              : null,
                        ))])),
                const PopupMenuDivider(),
                ...warehouses.map(
                  (warehouse) => PopupMenuItem(
                    value: warehouse,
                    child: Row(
                      children: [
                        Icon(
                          Icons.warehouse_rounded,
                          size: 20,
                          color: currentFilter == warehouse
                              ? theme.colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: Breakpoints.paddingS),
                        Text(
                          warehouse,
                          style: TextStyle(
                            color: currentFilter == warehouse
                                ? theme.colorScheme.primary
                                : null,
                            fontWeight: currentFilter == warehouse
                                ? FontWeight.bold
                                : null,
                          ))])))]),
          const SizedBox(width: Breakpoints.paddingS),
        ]),
      body: Column(
        children: [
          if (currentFilter != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(Breakpoints.paddingM),
              padding: const EdgeInsets.all(Breakpoints.paddingM),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: Breakpoints.paddingS),
                  Expanded(
                    child: Text(
                      'Отображаются остатки склада "$currentFilter"',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary))),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    tooltip: 'Сбросить фильтр',
                    onPressed: () {
                      ref.read(warehouseFilterProvider.notifier).state = null;
                    })])),

          // Список остатков
          const Expanded(child: StockList()),
        ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRouter.goToAddStock(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Добавить остаток'),
      ));
  }
}
