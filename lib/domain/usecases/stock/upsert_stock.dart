import '../../entities/stock.dart';
import '../../repositories/stock_repository.dart';

/// Use Case для добавления или обновления складского остатка
class UpsertStock {
  final StockRepository repo;
  
  UpsertStock(this.repo);
  
  Future<void> call(StockEntity stock) => repo.upsert(stock);
}
