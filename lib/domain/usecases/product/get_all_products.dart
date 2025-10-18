import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

/// Use Case для получения всех продуктов
/// Сортировка должна выполняться отдельным use case (SortProductsUseCase)
class GetAllProducts {
  final ProductRepository repo;
  
  GetAllProducts(this.repo);
  
  Future<List<ProductEntity>> call() => repo.getAll();
}
