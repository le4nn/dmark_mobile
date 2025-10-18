import '../../repositories/product_repository.dart';

/// Use Case для удаления продукта по GTIN
class DeleteProduct {
  final ProductRepository repo;
  
  DeleteProduct(this.repo);
  
  Future<void> call(String gtin) => repo.delete(gtin);
}
