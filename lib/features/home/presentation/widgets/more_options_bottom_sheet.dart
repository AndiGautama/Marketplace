import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';

class MoreOptionsBottomSheet extends StatelessWidget {
  const MoreOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          _buildOptionItem(
            context,
            icon: Icons.receipt_long_outlined,
            title: 'Riwayat Belanja',
            onTap: () {
              Navigator.pop(context);
              context.go('/history/${TransactionType.purchase.name}');
            },
          ),
          _buildOptionItem(
            context,
            icon: Icons.add_card_outlined,
            title: 'Riwayat Isi Saldo',
            onTap: () {
              Navigator.pop(context);
              context.go('/history/${TransactionType.topUp.name}');
            },
          ),
          _buildOptionItem(
            context,
            icon: Icons.redeem_outlined,
            title: 'Riwayat Tukar Poin',
            onTap: () {
              Navigator.pop(context);
              context.go('/history/${TransactionType.pointRedemption.name}');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}