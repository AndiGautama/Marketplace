import 'package:flutter/material.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/home/domain/services/user_stats_service.dart';

class StatsCardWidget extends StatelessWidget {
  const StatsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserStats>(
      valueListenable: UserStatsService.instance.stats,
      builder: (context, userStats, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, Icons.shopping_bag_outlined, userStats.orderCount.toString(), "Pesanan"),
                _buildStatItem(context, Icons.rate_review_outlined, userStats.reviewCount.toString(), "Ulasan"),
                Flexible(
                  child: _buildStatItem(
                    context,
                    Icons.account_balance_wallet_outlined,
                    AppFormatter.formatRupiah(userStats.monthlySpending),
                    "Pengeluaran Bulan Ini"
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}