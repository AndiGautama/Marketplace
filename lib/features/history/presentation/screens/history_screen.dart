import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:marketplace2/features/history/data/repositories/history_repository.dart';

// Ubah menjadi StatefulWidget
class HistoryScreen extends StatefulWidget {
  final TransactionType? filter;
  const HistoryScreen({super.key, this.filter});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<TransactionModel>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    // Ambil data hanya satu kali saat halaman pertama kali dibuat
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final historyRepo = context.read<HistoryRepository>();
      _transactionsFuture = historyRepo.getTransactions(authState.user.email);
    } else {
      // Jika entah bagaimana pengguna tidak login, siapkan future kosong
      _transactionsFuture = Future.value([]);
    }
  }

  String _getPageTitle() {
    if (widget.filter == null) return 'Semua Riwayat';
    switch (widget.filter!) {
      case TransactionType.purchase:
        return 'Riwayat Belanja';
      case TransactionType.topUp:
        return 'Riwayat Isi Saldo';
      case TransactionType.pointRedemption:
        return 'Riwayat Tukar Poin';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(_getPageTitle()),
      ),
      body: authState is AuthSuccess
          ? FutureBuilder<List<TransactionModel>>(
              future: _transactionsFuture, // Gunakan future dari state
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada riwayat.'));
                }
                
                var transactions = snapshot.data!;
                if (widget.filter != null) {
                  transactions = transactions.where((t) => t.type == widget.filter).toList();
                }

                if (transactions.isEmpty) {
                  return const Center(child: Text('Tidak ada riwayat untuk kategori ini.'));
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionTile(context, transactions[index]);
                  },
                );
              },
            )
          : const Center(child: Text('Silakan login untuk melihat riwayat.')),
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel trx) {
    IconData icon;
    Color color;
    String amountString;
    String pointString = '';

    switch (trx.type) {
      case TransactionType.purchase:
        icon = Icons.shopping_bag_outlined;
        color = Colors.red;
        amountString = '- Rp ${(-trx.amountChange).toStringAsFixed(0)}';
        if (trx.pointsChange > 0) {
          pointString = '+${trx.pointsChange} Poin';
        }
        break;
      case TransactionType.topUp:
        icon = Icons.account_balance_wallet_outlined;
        color = Colors.green;
        amountString = '+ Rp ${trx.amountChange.toStringAsFixed(0)}';
        break;
      case TransactionType.pointRedemption:
        icon = Icons.star_outline;
        color = Colors.orange;
        amountString = '${trx.pointsChange} Poin';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(trx.description, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('d MMMM yyyy, HH:mm').format(trx.date)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amountString,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (pointString.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                pointString,
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              )
            ]
          ],
        ),
      ),
    );
  }
}