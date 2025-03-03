import 'package:flutter/material.dart';
import 'package:ecommerceproducts_app/model/productItem.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductItem> _products = [];

  List<ProductItem> get products => _products;

  void addProduct(ProductItem product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(int index, ProductItem updatedProduct) {
    _products[index] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void restoreProduct(int index, ProductItem product) {
    _products.insert(index, product);
    notifyListeners();
  }
}
