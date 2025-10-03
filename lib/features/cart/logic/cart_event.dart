part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

// Event saat pengguna menekan "Masukkan ke keranjang"
class AddProductToCart extends CartEvent {
  final ProductModel product;
  const AddProductToCart(this.product);
  @override
  List<Object> get props => [product];
}

// Event saat pengguna menekan tombol '+' di keranjang
class IncrementCartItem extends CartEvent {
  final ProductModel product;
  const IncrementCartItem(this.product);
  @override
  List<Object> get props => [product];
}

// Event saat pengguna menekan tombol '-' di keranjang
class DecrementCartItem extends CartEvent {
  final ProductModel product;
  const DecrementCartItem(this.product);
  @override
  List<Object> get props => [product];
}

// Event saat pengguna menekan tombol hapus di keranjang
class RemoveFromCart extends CartEvent {
  final ProductModel product;
  const RemoveFromCart(this.product);
  @override
  List<Object> get props => [product];
}

// Event baru untuk mengosongkan keranjang
class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {
  final String userEmail;
  const LoadCart({required this.userEmail});
  @override
  List<Object> get props => [userEmail];
}