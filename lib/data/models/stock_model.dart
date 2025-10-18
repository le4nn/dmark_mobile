import 'package:hive/hive.dart';
import '../../domain/entities/stock.dart';

@HiveType(typeId: 2)
class StockModel extends HiveObject {
  @HiveField(0)
  String warehouse;
  @HiveField(1)
  String productGtin;
  @HiveField(2)
  int quantity;

  StockModel({
    required this.warehouse,
    required this.productGtin,
    required this.quantity,
  });

  factory StockModel.fromEntity(StockEntity e) => StockModel(
    warehouse: e.warehouse,
    productGtin: e.productGtin,
    quantity: e.quantity,
  );

  StockEntity toEntity() => StockEntity(
    warehouse: warehouse,
    productGtin: productGtin,
    quantity: quantity,
  );
}

class StockModelAdapter extends TypeAdapter<StockModel> {
  @override
  final int typeId = 2;

  @override
  StockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return StockModel(
      warehouse: fields[0] as String,
      productGtin: fields[1] as String,
      quantity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.warehouse)
      ..writeByte(1)
      ..write(obj.productGtin)
      ..writeByte(2)
      ..write(obj.quantity);
  }
}
