part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

// State awal atau saat keranjang belum dimuat
class CartInitial extends CartState {}

// State ketika keranjang sudah dimuat (bisa kosong atau berisi)
class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  const CartLoaded({this.items = const [], this.totalPrice = 0.0});

  @override
  List<Object> get props => [items, totalPrice];
}