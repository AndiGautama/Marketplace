import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:marketplace2/features/history/data/repositories/history_repository.dart';
import 'package:marketplace2/features/wallet/logic/wallet_bloc.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final quickAmounts = [50000.0, 100000.0, 200000.0, 500000.0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Saldo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN BARU: SALDO SAAT INI ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  String currentBalance = 'Rp 0';
                  if (state is WalletLoaded) {
                    currentBalance = AppFormatter.formatRupiah(state.balance);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saldo Anda Saat Ini', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(currentBalance, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // --- BAGIAN INPUT NOMINAL ---
            const Text('Masukkan Jumlah Top Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '0',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN PILIH CEPAT ---
            const Text('Pilih Cepat:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: quickAmounts.map((amount) {
                return _buildQuickAmountCard(
                  context,
                  amount: amount,
                  onTap: () {
                    final formatter = NumberFormat.decimalPattern('id_ID');
                    amountController.text = formatter.format(amount);
                    amountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: amountController.text.length));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 48),

            // --- TOMBOL TOP UP ---
            ElevatedButton(
              onPressed: () {
                final String cleanText = amountController.text.replaceAll('.', '');
                final amount = double.tryParse(cleanText);
                final authState = context.read<AuthBloc>().state;

                if (authState is AuthSuccess) {
                  if (amount != null && amount > 0) {
                    final transaction = TransactionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: TransactionType.topUp,
                      description: 'Isi Saldo',
                      amountChange: amount,
                      pointsChange: 0,
                      date: DateTime.now(),
                    );
                    context.read<HistoryRepository>().addTransaction(authState.user.email, transaction);

                    context.read<WalletBloc>().add(TopUpBalance(
                          amount: amount,
                          userEmail: authState.user.email,
                        ));

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Top up sebesar ${AppFormatter.formatRupiah(amount)} berhasil!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    context.go('/profile');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Masukkan jumlah yang valid.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesi Anda berakhir, silakan login kembali.')),
                  );
                  context.go('/login');
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Top Up Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk kartu pilihan cepat
  Widget _buildQuickAmountCard(BuildContext context, {
    required double amount,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            AppFormatter.formatRupiah(amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}