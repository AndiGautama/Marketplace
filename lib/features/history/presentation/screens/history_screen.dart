import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:marketplace2/features/history/data/repositories/history_repository.dart';

class HistoryScreen extends StatefulWidget {
  final TransactionType? filter;
  const HistoryScreen({super.key, this.filter});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<TransactionModel>> _transactionsFuture;

  final Color primaryGrey = Colors.grey.shade800;
  final Color backgroundGrey = Colors.grey.shade100;
  final Color appBarBackground = Colors.grey.shade200;
  final Color cardBackground = Colors.white;
  final Color secondaryText = Colors.grey.shade600;

  final Color purchaseColor = Colors.red.shade700;
  final Color topUpColor = Colors.green.shade600;
  final Color pointRedemptionColor = Colors.orange.shade600;
  final Color pointEarnedColor = Colors.green.shade500;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final historyRepo = context.read<HistoryRepository>();
      _transactionsFuture = historyRepo.getTransactions(authState.user.email);
    } else {
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
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGrey),
          onPressed: () => context.go('/'),
        ),
        title: Text(_getPageTitle(), style: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold)),
        backgroundColor: appBarBackground,
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: authState is AuthSuccess
          ? FutureBuilder<List<TransactionModel>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: primaryGrey));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi error: ${snapshot.error}', style: TextStyle(color: secondaryText)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada riwayat.', style: TextStyle(color: secondaryText)));
                }

                var transactions = snapshot.data!;
                if (widget.filter != null) {
                  transactions = transactions.where((t) => t.type == widget.filter).toList();
                }

                if (transactions.isEmpty) {
                  return Center(child: Text('Tidak ada riwayat untuk kategori ini.', style: TextStyle(color: secondaryText)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionTile(context, transactions[index]);
                  },
                );
              },
            )
          : Center(child: Text('Silakan login untuk melihat riwayat.', style: TextStyle(color: secondaryText))),
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
        color = purchaseColor;
        amountString = '- ${AppFormatter.formatRupiah(-trx.amountChange)}';
        if (trx.pointsChange > 0) {
          pointString = '+${trx.pointsChange} Poin';
        }
        break;
      case TransactionType.topUp:
        icon = Icons.account_balance_wallet_outlined;
        color = topUpColor;
        amountString = '+ ${AppFormatter.formatRupiah(trx.amountChange)}';
        break;
      case TransactionType.pointRedemption:
        icon = Icons.star_outline;
        color = pointRedemptionColor;
        amountString = '${trx.pointsChange} Poin';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300)
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          trx.description,
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryGrey)
        ),
        subtitle: Text(
          DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(trx.date),
          style: TextStyle(color: secondaryText)
        ),
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
                style: TextStyle(color: pointEarnedColor, fontWeight: FontWeight.w500, fontSize: 12),
              )
            ]
          ],
        ),
      ),
    );
  }
}