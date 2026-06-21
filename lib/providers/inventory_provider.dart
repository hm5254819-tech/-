import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class InventoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'products';
  List<Product> _products = [];
  final Uuid _uuid = const Uuid();
  bool _initialized = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_products);
  String? get error => _error;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _firestore.collection(_collection).snapshots().listen(
      (snapshot) {
        _error = null;
        _products = snapshot.docs.map((doc) {
          return Product.fromMap(doc.id, doc.data());
        }).toList();
        _products.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        debugPrint('Firestore snapshot error: $e');
        notifyListeners();
      },
    );
  }

  Future<void> addProduct(String name, int quantity) async {
    try {
      final id = _uuid.v4();
      final product = Product(id: id, name: name, quantity: quantity);
      await _firestore.collection(_collection).doc(id).set(product.toMap());
    } catch (e) {
      _error = e.toString();
      debugPrint('Add product error: $e');
      notifyListeners();
    }
  }

  Future<void> incrementQuantity(String id) async {
    try {
      final ref = _firestore.collection(_collection).doc(id);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(ref);
        if (!snapshot.exists) return;
        final currentQty = (snapshot.data()?['quantity'] ?? 0) as int;
        transaction.update(ref, {
          'quantity': currentQty + 1,
          'lastUpdated': Timestamp.now(),
        });
      });
    } catch (e) {
      _error = e.toString();
      debugPrint('Increment error: $e');
      notifyListeners();
    }
  }

  Future<void> decrementQuantity(String id) async {
    try {
      final ref = _firestore.collection(_collection).doc(id);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(ref);
        if (!snapshot.exists) return;
        final currentQty = (snapshot.data()?['quantity'] ?? 0) as int;
        if (currentQty <= 0) return;
        transaction.update(ref, {
          'quantity': currentQty - 1,
          'lastUpdated': Timestamp.now(),
        });
      });
    } catch (e) {
      _error = e.toString();
      debugPrint('Decrement error: $e');
      notifyListeners();
    }
  }

  int totalProducts() => _products.length;
}
