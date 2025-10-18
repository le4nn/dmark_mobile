import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

/// Use Case для получения продукта по GTIN
class GetProductByGtin {
  final ProductRepository repo;
  
  GetProductByGtin(this.repo);
  
  Future<ProductEntity?> call(String gtin) => repo.getByGtin(gtin);
}
