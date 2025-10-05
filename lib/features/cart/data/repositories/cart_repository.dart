import 'dart:convert';
import 'package:marketplace2/features/cart/data/models/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  Future<List<CartItem>> loadCart(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userEmail}_cart';
    final String? cartString = prefs.getString(key);

    if (cartString != null) {
      final List<dynamic> cartListJson = jsonDecode(cartString);
      return cartListJson.map((json) => CartItem.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveCart(String userEmail, List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userEmail}_cart';
    final String cartString = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(key, cartString);
  }
}