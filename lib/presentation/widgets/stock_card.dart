import 'package:flutter/material.dart';

import '../../domain/entities/stock.dart';
import '../../core/constants/breakpoints.dart';
import '../../core/theme/app_colors.dart';

/// Карточка остатка на складе
class StockCard extends StatelessWidget {
  final StockEntity stock;
  final String? productName;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(int)? onDecreaseQuantity;

  const StockCard({
    super.key,
    required this.stock,
    this.productName,
    this.onTap,
    this.onDelete,
    this.onDecreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Breakpoints.paddingM,
        vertical: Breakpoints.paddingS,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Breakpoints.borderRadiusL),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Breakpoints.borderRadiusL),
        child: Padding(
          padding: const EdgeInsets.all(Breakpoints.paddingM),
          child: Row(
            children: [
              // Иконка склада
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getQuantityColor(context, stock.quantity)
                      .withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
                ),
                child: Icon(
                  Icons.warehouse_rounded,
                  size: 28,
                  color: _getQuantityColor(context, stock.quantity))),
              const SizedBox(width: Breakpoints.paddingM),

              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название склада
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            stock.warehouse,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))]),
                    const SizedBox(height: 4),

                    // Название продукта или GTIN
                    Text(
                      productName ?? 'GTIN: ${stock.productGtin}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Количество
                    Row(
                      children: [
                        Icon(
                          _getQuantityIcon(stock.quantity),
                          size: 16,
                          color: _getQuantityColor(context, stock.quantity),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${stock.quantity} шт.',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: _getQuantityColor(context, stock.quantity),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getQuantityColor(context, stock.quantity)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getQuantityStatus(stock.quantity),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getQuantityColor(context, stock.quantity),
                              fontWeight: FontWeight.bold,
                            )))])])),

              // Кнопка уменьшения количества
              if (onDecreaseQuantity != null && stock.quantity > 0)
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline_rounded,
                    color: AppColors.warning,
                  ),
                  tooltip: 'Уменьшить количество',
                  onPressed: () async {
                    // Показать диалог для ввода количества
                    final decreaseAmount = await _showDecreaseDialog(context);
                    if (decreaseAmount != null && decreaseAmount > 0) {
                      onDecreaseQuantity!(decreaseAmount);
                    }
                  },
                ),
              
              // Кнопка удаления
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: 'Удалить',
                  onPressed: onDelete,
                )]))));
  }

  /// Получить цвет в зависимости от количества
  Color _getQuantityColor(BuildContext context, int quantity) {
    if (quantity == 0) {
      return AppColors.stockEmpty;
    } else if (quantity < 10) {
      return AppColors.stockLow;
    } else if (quantity < 50) {
      return AppColors.stockMedium;
    } else {
      return AppColors.stockHigh;
    }
  }

  /// Получить иконку в зависимости от количества
  IconData _getQuantityIcon(int quantity) {
    if (quantity == 0) {
      return Icons.warning_rounded;
    } else if (quantity < 10) {
      return Icons.trending_down_rounded;
    } else if (quantity < 50) {
      return Icons.inventory_2_rounded;
    } else {
      return Icons.trending_up_rounded;
    }
  }

  /// Получить статус в зависимости от количества
  String _getQuantityStatus(int quantity) {
    if (quantity == 0) {
      return 'Нет в наличии';
    } else if (quantity < 10) {
      return 'Мало';
    } else if (quantity < 50) {
      return 'Средне';
    } else {
      return 'Много';
    }
  }

  /// Показать диалог для уменьшения количества
  Future<int?> _showDecreaseDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.remove_circle_outline_rounded,
          size: 32,
          color: AppColors.warning,
        ),
        title: const Text('Уменьшить количество'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Текущее количество: ${stock.quantity} шт.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Сколько отнять?',
                suffixText: 'шт.',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
              onSubmitted: (value) {
                final amount = int.tryParse(value);
                if (amount != null && amount > 0 && amount <= stock.quantity) {
                  Navigator.pop(context, amount);
                }
              })]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Введите корректное количество'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              if (amount > stock.quantity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Нельзя отнять больше чем есть (${stock.quantity} шт.)',
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
                return;
              }
              Navigator.pop(context, amount);
            },
            child: const Text('Отнять'),
          )]));
  }
}
