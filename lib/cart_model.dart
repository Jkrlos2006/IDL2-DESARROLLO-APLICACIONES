import 'package:flutter/foundation.dart';
import 'product.dart';

class CartModel extends ChangeNotifier {
  final Map<Product, int> _products = {};

  Map<Product, int> get products => _products;

  int getProductQuantity(Product product) {
    return _products[product] ?? 0;
  }

  void increaseProductQuantity(Product product) {
    if (_products.containsKey(product)) {
      _products[product] = _products[product]! + 1;
    } else {
      _products[product] = 1;
    }
    notifyListeners();
  }

  void decreaseProductQuantity(Product product) {
    if (_products.containsKey(product)) {
      if (_products[product]! > 0) {
        _products[product] = _products[product]! - 1;
      }
      notifyListeners();
    }
  }

  void addProduct(Product product, int quantity) {
    if (_products.containsKey(product)) {
      _products[product] = _products[product]! + quantity;
    } else {
      _products[product] = quantity;
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    if (_products.containsKey(product)) {
      if (_products[product]! > 1) {
        _products[product] = _products[product]! - 1;
      } else {
        _products.remove(product);
      }
      notifyListeners();
    }
  }

  double totalPrice() {
    double total = 0;
    _products.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }
}
