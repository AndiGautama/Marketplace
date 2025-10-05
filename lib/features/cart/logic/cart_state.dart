part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  const CartLoaded({this.items = const [], this.totalPrice = 0.0});

  @override
  List<Object> get props => [items, totalPrice];
}