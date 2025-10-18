import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/breakpoints.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import '../widgets/stock_list.dart';

/// Страница добавления/редактирования остатков
class AddEditStockPage extends ConsumerStatefulWidget {
  final StockEntity? initialStock;

  const AddEditStockPage({super.key, this.initialStock});

  @override
  ConsumerState<AddEditStockPage> createState() => _AddEditStockPageState();
}

class _AddEditStockPageState extends ConsumerState<AddEditStockPage> {
  final _formKey = GlobalKey<FormState>();
  final _warehouseCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();

  String? _selectedGtin;
  List<ProductEntity> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    
    if (widget.initialStock != null) {
      _warehouseCtrl.text = widget.initialStock!.warehouse;
      _selectedGtin = widget.initialStock!.productGtin;
      _quantityCtrl.text = widget.initialStock!.quantity.toString();
    }
  }

  Future<void> _loadProducts() async {
    try {
      final getAllProducts = ref.read(getAllProductsProvider);
      _products = await getAllProducts();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки продуктов: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
      }
    }
  }

  @override
  void dispose() {
    _warehouseCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGtin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите товар'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final warehouse = _warehouseCtrl.text.trim();
    final gtin = _selectedGtin!;
    final quantity = int.parse(_quantityCtrl.text.trim());

    try {
      // Проверяем есть ли уже этот товар на складе
      final getStockList = ref.read(getStockListProvider);
      final allStocks = await getStockList();
      final existingStock = allStocks.firstWhere(
        (s) => s.warehouse == warehouse && s.productGtin == gtin,
        orElse: () => StockEntity(
          warehouse: warehouse,
          productGtin: gtin,
          quantity: 0,
        ),
      );

      // Если редактируем существующий - заменяем количество
      // Если добавляем к существующему - увеличиваем
      final newQuantity = widget.initialStock != null
          ? quantity // Редактирование - устанавливаем новое значение
          : existingStock.quantity + quantity; // Добавление - суммируем

      final stockEntity = StockEntity(
        warehouse: warehouse,
        productGtin: gtin,
        quantity: newQuantity,
      );

      await ref.read(upsertStockProvider)(stockEntity);
      ref.invalidate(stocksProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.initialStock != null
                  ? 'Остаток обновлён'
                  : existingStock.quantity > 0
                      ? 'Количество увеличено на $quantity шт.'
                      : 'Остаток добавлен',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка сохранения: $e'),
            backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialStock != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать остаток' : 'Добавить остаток'),
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Breakpoints.paddingM),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Информационная карточка
                    Container(
                      padding: const EdgeInsets.all(Breakpoints.paddingM),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: Breakpoints.paddingS),
                          Expanded(
                            child: Text(
                              isEditing
                                  ? 'Измените количество товара на складе'
                                  : 'Если товар уже есть на складе, количество будет увеличено',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,)))])),
                    const SizedBox(height: Breakpoints.paddingL),
                    TextFormField(
                      controller: _warehouseCtrl,
                      enabled: !isEditing,
                      decoration: InputDecoration(
                        labelText: 'Склад',
                        hintText: 'Например: Склад А',
                        prefixIcon: const Icon(Icons.warehouse_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM))),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Укажите склад' : null,
                    ),
                    const SizedBox(height: Breakpoints.paddingM),
                    DropdownButtonFormField<String>(
                      value: _selectedGtin,
                      decoration: InputDecoration(
                        labelText: 'Товар',
                        prefixIcon: const Icon(Icons.inventory_2_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
                        ),
                      ),
                      hint: const Text('Выберите товар'),
                      isExpanded: true,
                      items: _products.map((product) {
                        return DropdownMenuItem<String>(
                          value: product.gtin,
                          enabled: !isEditing,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                product.gtin,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant))]));
                      }).toList(),
                      onChanged: isEditing
                          ? null
                          : (value) {
                              setState(() {
                                _selectedGtin = value;
                              });
                            },
                      validator: (v) => v == null ? 'Выберите товар' : null,
                    ),
                    const SizedBox(height: Breakpoints.paddingM),
                    TextFormField(
                      controller: _quantityCtrl,
                      decoration: InputDecoration(
                        labelText: isEditing ? 'Новое количество' : 'Количество для добавления',
                        hintText: '0',
                        prefixIcon: const Icon(Icons.numbers_rounded),
                        suffixText: 'шт.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Breakpoints.borderRadiusM),
                        ),
                        helperText: isEditing
                            ? 'Установите новое количество'
                            : 'Если товар уже есть, это количество будет добавлено',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Укажите количество';
                        }
                        final quantity = int.tryParse(v.trim());
                        if (quantity == null || quantity < 0) {
                          return 'Количество должно быть ≥ 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Breakpoints.paddingL),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(isEditing ? 'Обновить' : 'Добавить'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(Breakpoints.paddingM),
                      ))]))),
    );
  }
}
