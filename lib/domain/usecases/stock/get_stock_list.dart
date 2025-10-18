import '../../entities/stock.dart';
import '../../repositories/stock_repository.dart';

/// Use Case для получения списка складских остатков
class GetStockList {
  final StockRepository repo;
  
  GetStockList(this.repo);
  
  Future<List<StockEntity>> call({String? warehouse}) =>
      repo.getAll(warehouse: warehouse);
}
