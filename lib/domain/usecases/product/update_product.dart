import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

/// Use Case для обновления существующего продукта
class UpdateProduct {
  final ProductRepository repo;
  
  UpdateProduct(this.repo);
  
  Future<void> call(ProductEntity product) => repo.update(product);
}
