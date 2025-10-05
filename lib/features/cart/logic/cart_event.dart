part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class AddProductToCart extends CartEvent {
  final ProductModel product;
  const AddProductToCart(this.product);
  @override
  List<Object> get props => [product];
}

class IncrementCartItem extends CartEvent {
  final ProductModel product;
  const IncrementCartItem(this.product);
  @override
  List<Object> get props => [product];
}

class DecrementCartItem extends CartEvent {
  final ProductModel product;
  const DecrementCartItem(this.product);
  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final ProductModel product;
  const RemoveFromCart(this.product);
  @override
  List<Object> get props => [product];
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {
  final String userEmail;
  const LoadCart({required this.userEmail});
  @override
  List<Object> get props => [userEmail];
}