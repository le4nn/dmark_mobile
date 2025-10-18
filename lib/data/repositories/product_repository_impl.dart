import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/hive/hive_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final HiveDataSource dataSource;
  ProductRepositoryImpl(this.dataSource);

  @override
  Future<void> add(ProductEntity product) =>
      dataSource.upsertProduct(ProductModel.fromEntity(product));

  @override
  Future<void> update(ProductEntity product) =>
      dataSource.upsertProduct(ProductModel.fromEntity(product));

  @override
  Future<void> delete(String gtin) => dataSource.deleteProduct(gtin);

  @override
  Future<ProductEntity?> getByGtin(String gtin) async {
    final m = await dataSource.getProduct(gtin);
    return m?.toEntity();
  }

  @override
  Future<List<ProductEntity>> getAll() async {
    final list = await dataSource.getAllProducts();
    return list.map((e) => e.toEntity()).toList();
  }
}
