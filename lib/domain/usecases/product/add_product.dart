import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

/// Use Case для добавления нового продукта
class AddProduct {
  final ProductRepository repo;
  
  AddProduct(this.repo);
  
  Future<void> call(ProductEntity product) => repo.add(product);
}
