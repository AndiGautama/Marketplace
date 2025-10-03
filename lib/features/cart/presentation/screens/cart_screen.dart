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

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
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
                      return _buildCartItemCard(context, cartItem);
                    },
                  ),
                ),
                _buildCheckoutSection(context, state),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem cartItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
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
              ),
              child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    AppFormatter.formatRupiah(cartItem.product.price),
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
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
                Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                  onPressed: () => context.read<CartBloc>().add(IncrementCartItem(cartItem.product)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartLoaded cartState) {
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
              const Text('Total Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                AppFormatter.formatRupiah(totalPrice), // Format harga
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // --- LOGIKA CHECKOUT LENGKAP ---
              final authState = context.read<AuthBloc>().state;
              final walletState = context.read<WalletBloc>().state;

              if (authState is AuthSuccess && walletState is WalletLoaded) {
                // 1. Cek Saldo Cukup
                if (walletState.balance < totalPrice) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saldo Anda tidak cukup!'), backgroundColor: Colors.red),
                  );
                  return; // Hentikan proses jika saldo tidak cukup
                }

                // 2. Hitung Poin
                final int pointsEarned = (totalPrice / 10000).floor();

                // 3. Catat Transaksi Belanja ke Riwayat
                final transaction = TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: TransactionType.purchase,
                  description: 'Pembelian ${cartState.items.length} jenis item',
                  amountChange: -totalPrice, // Saldo berkurang
                  pointsChange: pointsEarned, // Poin bertambah
                  date: DateTime.now(),
                );
                context.read<HistoryRepository>().addTransaction(authState.user.email, transaction);

                // 4. Kirim Event untuk memproses pembelian (kurangi saldo & tambah poin)
                context.read<WalletBloc>().add(ProcessPurchase(
                      amountToSubtract: totalPrice,
                      pointsToAdd: pointsEarned,
                      userEmail: authState.user.email,
                    ));
                
                // 5. Kirim Event untuk Kosongkan Keranjang
                context.read<CartBloc>().add(ClearCart());

                // 6. Tampilkan Notifikasi Sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pembelian berhasil! Anda mendapatkan $pointsEarned poin.'),
                    backgroundColor: Colors.green,
                  ),
                );

                // 7. Arahkan ke Halaman Home
                context.go('/');

              } else {
                // Jika pengguna entah bagaimana tidak login, arahkan ke halaman login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan login untuk melanjutkan.')),
                );
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('CHECKOUT'),
          ),
        ],
      ),
    );
  }
}