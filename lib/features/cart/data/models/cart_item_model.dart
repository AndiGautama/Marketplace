import 'package:equatable/equatable.dart';
import 'package:marketplace2/features/store/data/models/product_model.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}