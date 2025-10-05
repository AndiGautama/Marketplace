import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace2/features/cart/data/models/cart_item_model.dart';
import 'package:marketplace2/features/cart/data/repositories/cart_repository.dart';
import 'package:marketplace2/features/store/data/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  String? _currentUserEmail;

  CartBloc({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(const CartLoaded()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<IncrementCartItem>(_onIncrementCartItem);
    on<DecrementCartItem>(_onDecrementCartItem);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  double _calculateTotalPrice(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    _currentUserEmail = event.userEmail;
    final items = await _cartRepository.loadCart(_currentUserEmail!);
    emit(CartLoaded(items: items, totalPrice: _calculateTotalPrice(items)));
  }

  void _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      final List<CartItem> updatedItems = List.from(state.items);
      final existingItemIndex = updatedItems.indexWhere((item) => item.product.id == event.product.id);

      if (existingItemIndex != -1) {
        final existingItem = updatedItems[existingItemIndex];
        updatedItems[existingItemIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
      } else {
        updatedItems.add(CartItem(product: event.product));
      }

      if (_currentUserEmail != null) {
        _cartRepository.saveCart(_currentUserEmail!, updatedItems);
      }
      emit(CartLoaded(items: updatedItems, totalPrice: _calculateTotalPrice(updatedItems)));
    }
  }

  void _onIncrementCartItem(IncrementCartItem event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      final List<CartItem> updatedItems = List.from(state.items);
      final itemIndex = updatedItems.indexWhere((item) => item.product.id == event.product.id);

      if (itemIndex != -1) {
        final item = updatedItems[itemIndex];
        updatedItems[itemIndex] = item.copyWith(quantity: item.quantity + 1);

        if (_currentUserEmail != null) {
          _cartRepository.saveCart(_currentUserEmail!, updatedItems);
        }
        emit(CartLoaded(items: updatedItems, totalPrice: _calculateTotalPrice(updatedItems)));
      }
    }
  }

  void _onDecrementCartItem(DecrementCartItem event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      final List<CartItem> updatedItems = List.from(state.items);
      final itemIndex = updatedItems.indexWhere((item) => item.product.id == event.product.id);

      if (itemIndex != -1) {
        final item = updatedItems[itemIndex];
        if (item.quantity > 1) {
          updatedItems[itemIndex] = item.copyWith(quantity: item.quantity - 1);
        } else {
          updatedItems.removeAt(itemIndex);
        }

        if (_currentUserEmail != null) {
          _cartRepository.saveCart(_currentUserEmail!, updatedItems);
        }
        emit(CartLoaded(items: updatedItems, totalPrice: _calculateTotalPrice(updatedItems)));
      }
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      final List<CartItem> updatedItems = List.from(state.items);
      updatedItems.removeWhere((item) => item.product.id == event.product.id);

      if (_currentUserEmail != null) {
        _cartRepository.saveCart(_currentUserEmail!, updatedItems);
      }
      emit(CartLoaded(items: updatedItems, totalPrice: _calculateTotalPrice(updatedItems)));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    if (_currentUserEmail != null) {
      _cartRepository.saveCart(_currentUserEmail!, []);
    }
    _currentUserEmail = null;
    emit(const CartLoaded(items: [], totalPrice: 0.0));
  }
}