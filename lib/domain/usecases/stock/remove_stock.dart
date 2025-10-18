import '../../repositories/stock_repository.dart';

/// Use Case для удаления складского остатка
class RemoveStock {
  final StockRepository repo;
  
  RemoveStock(this.repo);
  
  Future<void> call(String warehouse, String gtin, {int? quantity}) =>
      repo.remove(warehouse, gtin, quantity: quantity);
}
