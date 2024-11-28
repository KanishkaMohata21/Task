import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final existingProductIndex = state.indexWhere((p) => p.id == product.id);
    if (existingProductIndex != -1) {
      final updatedProduct = state[existingProductIndex].copyWith(
        quantity: state[existingProductIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingProductIndex),
        updatedProduct,
        ...state.sublist(existingProductIndex + 1),
      ];
    } else {
      state = [...state, product.copyWith(quantity: 1)];
    }
  }

  void increaseQuantity(Product product) {
    final existingProductIndex = state.indexWhere((p) => p.id == product.id);
    if (existingProductIndex != -1) {
      final updatedProduct = state[existingProductIndex].copyWith(
        quantity: state[existingProductIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingProductIndex),
        updatedProduct,
        ...state.sublist(existingProductIndex + 1),
      ];
    }
  }

  void decreaseQuantity(Product product) {
    final existingProductIndex = state.indexWhere((p) => p.id == product.id);
    if (existingProductIndex != -1) {
      final currentProduct = state[existingProductIndex];
      if (currentProduct.quantity > 1) {
        final updatedProduct = currentProduct.copyWith(
          quantity: currentProduct.quantity - 1,
        );
        state = [
          ...state.sublist(0, existingProductIndex),
          updatedProduct,
          ...state.sublist(existingProductIndex + 1),
        ];
      } else {
        state = [
          ...state.sublist(0, existingProductIndex),
          ...state.sublist(existingProductIndex + 1),
        ];
      }
    }
  }

  void removeFromCart(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }

  double get totalPrice {
    return state.fold(0,
        (sum, product) => sum + (product.discountedPrice * product.quantity));
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});
