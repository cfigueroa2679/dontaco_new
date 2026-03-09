import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total {
    double sum = 0;
    for (var item in _items) {
      sum += item.subtotal;
    }
    return sum;
  }

  // ⭐ AGREGA ITEMS SIN DUPLICAR — SUMA CANTIDADES SI YA EXISTE
  void addItem(CartItem newItem) {
    final index = _items.indexWhere(
      (item) => item.nombre == newItem.nombre && item.carne == newItem.carne,
    );

    if (index != -1) {
      _items[index].cantidad += newItem.cantidad;
    } else {
      _items.add(newItem);
    }

    notifyListeners();
  }

  // ⭐ ELIMINAR ITEM POR ÍNDICE
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // ⭐ AUMENTAR CANTIDAD
  void increaseQuantity(int index) {
    _items[index].cantidad++;
    notifyListeners();
  }

  // ⭐ DISMINUIR CANTIDAD (ELIMINA SI LLEGA A 0)
  void decreaseQuantity(int index) {
    if (_items[index].cantidad > 1) {
      _items[index].cantidad--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  // ⭐ LIMPIAR TODO EL CARRITO (tu método original)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ⭐ NUEVO MÉTODO — requerido por cart_screen.dart
  void clear() {
    _items.clear();
    notifyListeners();
  }
}