import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String gtin;
  @HiveField(2)
  bool isActive;
  @HiveField(3)
  double price;
  @HiveField(4)
  String? imagePath;
  @HiveField(5)
  DateTime createdAt;
  @HiveField(6)
  DateTime updatedAt;
  @HiveField(7)
  DateTime? deletedAt;

  ProductModel({
    required this.name,
    required this.gtin,
    required this.isActive,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.imagePath,
  });

  factory ProductModel.fromEntity(ProductEntity e) => ProductModel(
    name: e.name,
    gtin: e.gtin,
    isActive: e.isActive,
    price: e.price,
    imagePath: e.imagePath,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
    deletedAt: e.deletedAt,
  );

  ProductEntity toEntity() => ProductEntity(
    name: name,
    gtin: gtin,
    isActive: isActive,
    price: price,
    imagePath: imagePath,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );
}

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ProductModel(
      name: fields[0] as String,
      gtin: fields[1] as String,
      isActive: fields[2] as bool,
      price: (fields[3] as num).toDouble(),
      imagePath: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      deletedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.gtin)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.deletedAt);
  }
}
