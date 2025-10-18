import '../entities/product.dart';

/// Типы сортировки продуктов
enum ProductSortType {
  byName,
  byDate,
  byPrice,
}

/// Use Case для сортировки продуктов
/// Содержит бизнес-логику сортировки
class SortProductsUseCase {
  /// Сортировать продукты по указанному типу
  List<ProductEntity> call(
    List<ProductEntity> products,
    ProductSortType sortType,
  ) {
    final sorted = List<ProductEntity>.from(products);

    switch (sortType) {
      case ProductSortType.byName:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      
      case ProductSortType.byDate:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      
      case ProductSortType.byPrice:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
    }

    return sorted;
  }

  /// Сортировать по названию
  List<ProductEntity> sortByName(List<ProductEntity> products) {
    return call(products, ProductSortType.byName);
  }

  /// Сортировать по дате (новые первые)
  List<ProductEntity> sortByDate(List<ProductEntity> products) {
    return call(products, ProductSortType.byDate);
  }

  /// Сортировать по цене
  List<ProductEntity> sortByPrice(List<ProductEntity> products) {
    return call(products, ProductSortType.byPrice);
  }
}
