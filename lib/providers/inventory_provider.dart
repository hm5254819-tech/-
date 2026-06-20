import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class InventoryProvider extends ChangeNotifier {
  static const String _boxName = 'inventory';
  late Box<Product> _box;
  List<Product> _products = [];
  final Uuid _uuid = const Uuid();

  List<Product> get products => List.unmodifiable(_products);

  Future<void> init() async {
    _box = await Hive.openBox<Product>(_boxName);
    _products = _box.values.toList();
    _products.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    notifyListeners();
  }

  Future<void> addProduct(String name, int quantity) async {
    final product = Product(
      id: _uuid.v4(),
      name: name,
      quantity: quantity,
    );
    await _box.put(product.id, product);
    _products.insert(0, product);
    notifyListeners();
  }

  Future<void> incrementQuantity(String id) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) return;
    final product = _products[index];
    product.quantity++;
    product.lastUpdated = DateTime.now();
    await product.save();
    _products.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    notifyListeners();
  }

  Future<void> decrementQuantity(String id) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) return;
    final product = _products[index];
    if (product.quantity <= 0) return;
    product.quantity--;
    product.lastUpdated = DateTime.now();
    await product.save();
    _products.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    notifyListeners();
  }

  int totalProducts() => _products.length;
}
