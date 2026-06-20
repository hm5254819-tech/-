import 'package:hive_flutter/hive_flutter.dart';

class Product extends HiveObject {
  final String id;
  String name;
  int quantity;
  DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    this.quantity = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    return Product(
      id: reader.readString(),
      name: reader.readString(),
      quantity: reader.readInt(),
      lastUpdated: DateTime.fromMicrosecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.quantity);
    writer.writeInt(obj.lastUpdated.microsecondsSinceEpoch);
  }
}
