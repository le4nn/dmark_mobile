import 'package:flutter/material.dart';
import 'dart:io';
import '../../domain/entities/product.dart';
import '../../core/constants/breakpoints.dart';

/// Карточка товара для отображения в списке
/// Показывает основную информацию о продукте и кнопки действий
class ProductCard extends StatelessWidget {
  /// Данные товара для отображения
  final ProductEntity product;

  /// Обработчик нажатия на карточку (опционально)
  final VoidCallback? onTap;

  /// Обработчик удаления товара
  final VoidCallback? onDelete;

  /// Обработчик редактирования товара
  final VoidCallback? onEdit;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = product.imagePath != null && product.imagePath!.isNotEmpty;
    
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Breakpoints.paddingM,
        vertical: Breakpoints.paddingS,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
        child: Padding(
          padding: const EdgeInsets.all(Breakpoints.paddingM),
          child: Row(
            children: [
              // Product Icon/Image
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasImage && File(product.imagePath!).existsSync()
                    ? Image.file(
                        File(product.imagePath!),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        hasImage ? Icons.image_outlined : Icons.inventory_2_outlined,
                        size: 32,
                        color: theme.colorScheme.primary,
                      )),
              const SizedBox(width: Breakpoints.paddingM),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Breakpoints.paddingXS),
                    Text(
                      'GTIN: ${product.gtin}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Breakpoints.paddingXS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Breakpoints.paddingS,
                        vertical: Breakpoints.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(Breakpoints.borderRadiusS),
                      ),
                      child: Text(
                        '₸${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold)))])),
              if (onEdit != null)
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: onEdit,
                  tooltip: 'Редактировать продукт',
                ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Удалить продукт',
                )]))));
  }
}
