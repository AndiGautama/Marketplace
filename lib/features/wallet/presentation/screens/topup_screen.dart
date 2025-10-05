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

    final Color primaryGrey = Colors.grey.shade800;
    final Color backgroundGrey = Colors.grey.shade100;
    final Color appBarBackground = Colors.grey.shade200;
    final Color cardBackground = Colors.white;
    final Color inputBorderColor = Colors.grey.shade400;

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: Text('Top Up Saldo', style: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold)),
        backgroundColor: appBarBackground,
        foregroundColor: primaryGrey,
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
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
                      Text(currentBalance, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGrey)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            Text('Masukkan Jumlah Top Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryGrey)),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGrey),
              decoration: InputDecoration(
                hintText: '0',
                prefixText: 'Rp ',
                prefixStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: inputBorderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: inputBorderColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryGrey, width: 2)),
                fillColor: cardBackground,
                filled: true,
              ),
            ),
            const SizedBox(height: 24),

            Text('Pilih Cepat:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryGrey)),
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
                  primaryGrey: primaryGrey,
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                  backgroundColor: primaryGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Top Up Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountCard(BuildContext context, {
    required double amount,
    required VoidCallback onTap,
    required Color primaryGrey,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            AppFormatter.formatRupiah(amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryGrey,
            ),
          ),
        ),
      ),
    );
  }
}