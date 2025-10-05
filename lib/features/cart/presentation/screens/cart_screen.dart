import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/cart/data/models/cart_item_model.dart';
import 'package:marketplace2/features/cart/logic/cart_bloc.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:marketplace2/features/history/data/repositories/history_repository.dart';
import 'package:marketplace2/features/wallet/logic/wallet_bloc.dart';
import 'package:marketplace2/features/home/domain/services/user_stats_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryGrey = Colors.grey.shade800;
    final Color backgroundGrey = Colors.grey.shade100;
    final Color cardBackground = Colors.white;
    final Color appBarBackground = Colors.grey.shade200;

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: Text('Keranjang Belanja', style: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold)),
        backgroundColor: appBarBackground,
        foregroundColor: primaryGrey,
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('Keranjang Anda kosong', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.items[index];
                      return _buildCartItemCard(context, cartItem, cardBackground);
                    },
                  ),
                ),
                _buildCheckoutSection(context, state, primaryGrey),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem cartItem, Color cardBackground) {
    final Color primaryColor = Colors.grey.shade800;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(cartItem.product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text(
                    AppFormatter.formatRupiah(cartItem.product.price),
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                  onPressed: () => context.read<CartBloc>().add(DecrementCartItem(cartItem.product)),
                ),
                Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: primaryColor),
                  onPressed: () => context.read<CartBloc>().add(IncrementCartItem(cartItem.product)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartLoaded cartState, Color primaryGrey) {
    final totalPrice = cartState.totalPrice;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text(
                AppFormatter.formatRupiah(totalPrice),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGrey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              final walletState = context.read<WalletBloc>().state;

              if (authState is AuthSuccess && walletState is WalletLoaded) {
                if (walletState.balance < totalPrice) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saldo Anda tidak cukup!'), backgroundColor: Colors.red),
                  );
                  return;
                }

                final int pointsEarned = (totalPrice / 10000).floor();

                final transaction = TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: TransactionType.purchase,
                  description: 'Pembelian ${cartState.items.length} jenis item',
                  amountChange: -totalPrice,
                  pointsChange: pointsEarned,
                  date: DateTime.now(),
                );
                context.read<HistoryRepository>().addTransaction(authState.user.email, transaction);

                context.read<WalletBloc>().add(ProcessPurchase(
                      amountToSubtract: totalPrice,
                      pointsToAdd: pointsEarned,
                      userEmail: authState.user.email,
                    ));

                context.read<CartBloc>().add(ClearCart());

                UserStatsService.instance.addOrder(totalPrice);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pembelian berhasil! Anda mendapatkan $pointsEarned poin.'),
                    backgroundColor: Colors.green,
                  ),
                );

                context.go('/');

              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan login untuk melanjutkan.')),
                );
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('CHECKOUT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}