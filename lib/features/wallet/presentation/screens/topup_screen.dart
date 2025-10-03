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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Jumlah Top Up',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Cepat:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: quickAmounts.map((amount) {
                return ActionChip(
                  label: Text(AppFormatter.formatRupiah(amount)),
                  onPressed: () {
                    final formatter = NumberFormat.decimalPattern('id_ID');
                    amountController.text = formatter.format(amount);
                    amountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: amountController.text.length));
                  },
                );
              }).toList(),
            ),
            const Spacer(),
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

                    ScaffoldMessenger.of(
                      context,
                    )..hideCurrentSnackBar()..showSnackBar(
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
              child: const Text('Top Up Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}