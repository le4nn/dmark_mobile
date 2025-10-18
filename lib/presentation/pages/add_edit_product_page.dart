import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../core/utils/validators.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import '../widgets/product_list.dart';

class AddEditProductPage extends ConsumerStatefulWidget {
  const AddEditProductPage({super.key});

  @override
  ConsumerState<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends ConsumerState<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _gtinCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  ProductEntity? editing;
  String? _imagePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final maybe = ModalRoute.of(context)?.settings.arguments;
    if (maybe is ProductEntity && editing == null) {
      editing = maybe;
      _nameCtrl.text = maybe.name;
      _gtinCtrl.text = maybe.gtin;
      _priceCtrl.text = maybe.price.toStringAsFixed(2);
      _imagePath = maybe.imagePath;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _gtinCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1200);
    if (file != null) {
      setState(() {
        _imagePath = file.path;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final entity = ProductEntity(
      name: _nameCtrl.text.trim(),
      gtin: _gtinCtrl.text.trim(),
      isActive: true,
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
      createdAt: editing?.createdAt ?? now,
      updatedAt: now,
      imagePath: _imagePath,
      deletedAt: null,
    );
    if (editing == null) {
      await ref.read(addProductProvider)(entity);
    } else {
      await ref.read(updateProductProvider)(entity);
    }
    
    // Обновляем список продуктов после добавления/редактирования
    ref.invalidate(productsProvider);
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing == null ? 'Новый продукт' : 'Редактировать продукт',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image preview and controls
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 84,
                      height: 84,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: _imagePath != null && _imagePath!.isNotEmpty && File(_imagePath!).existsSync()
                          ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                          : Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilledButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_library_rounded),
                        label: const Text('Выбрать изображение'),
                      ),
                      const SizedBox(height: 8),
                      if (_imagePath != null && _imagePath!.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => setState(() => _imagePath = null),
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Удалить изображение'),
                        ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Название'),
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Обязательно' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _gtinCtrl,
                decoration: const InputDecoration(labelText: 'GTIN (13 цифр)'),
                keyboardType: TextInputType.number,
                maxLength: 13,
                validator: Validators.validateGtin13,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Цена'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
                validator:
                    (v) =>
                        (double.tryParse((v ?? '').replaceAll(',', '.')) ==
                                null)
                            ? 'Некорректная цена'
                            : null),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Сохранить'),
              )]))));
  }
}
