import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:marketplace2/features/history/data/repositories/history_repository.dart';
import 'package:marketplace2/features/loyalty/data/models/reward_model.dart';
import 'package:marketplace2/features/wallet/logic/wallet_bloc.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  // Data dummy untuk hadiah (hanya barang fisik)
  final List<RewardModel> _dummyRewards = const [
    RewardModel(id: 'r1', name: 'Stiker Set Eksklusif', pointCost: 50),
    RewardModel(id: 'r2', name: 'Gantungan Kunci Keren', pointCost: 100),
    RewardModel(id: 'r3', name: 'Mug Keren', pointCost: 250),
    RewardModel(id: 'r4', name: 'Topi Keren', pointCost: 300),
    RewardModel(id: 'r5', name: 'Botol Minum', pointCost: 400),
    RewardModel(id: 'r6', name: 'T-Shirt Eksklusif', pointCost: 500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tombol kembali akan muncul otomatis karena kita membukanya dengan context.push()
        title: const Text('Tukar Poin'),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, walletState) {
          if (walletState is WalletLoaded) {
            return Column(
              children: [
                // Bagian header yang menampilkan total poin
                _buildPointsHeader(context, walletState.points),
                // Daftar hadiah yang bisa ditukar
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _dummyRewards.length,
                    itemBuilder: (context, index) {
                      final reward = _dummyRewards[index];
                      final canRedeem = walletState.points >= reward.pointCost;
                      return _buildRewardCard(context, reward, canRedeem);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPointsHeader(BuildContext context, int points) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Text(
            'Poin Kamu Saat Ini',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '$points Poin',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, RewardModel reward, bool canRedeem) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Icon(Icons.card_giftcard, color: Theme.of(context).primaryColor),
        title: Text(reward.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${reward.pointCost} Poin'),
        trailing: ElevatedButton(
          // Tombol akan nonaktif (berwarna abu-abu) jika poin tidak cukup
          onPressed: canRedeem
              ? () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthSuccess) {
                    // 1. Catat transaksi tukar poin ke riwayat
                    final transaction = TransactionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: TransactionType.pointRedemption,
                      description: 'Tukar: ${reward.name}',
                      amountChange: 0,
                      pointsChange: -reward.pointCost, // Poin berkurang
                      date: DateTime.now(),
                    );
                    context
                        .read<HistoryRepository>()
                        .addTransaction(authState.user.email, transaction);

                    // 2. Kirim event RedeemPoints ke WalletBloc
                    context.read<WalletBloc>().add(RedeemPoints(
                          pointsToSubtract: reward.pointCost,
                          userEmail: authState.user.email,
                        ));

                    // 3. Tampilkan notifikasi sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Berhasil menukar ${reward.name}!'),
                          backgroundColor: Colors.green),
                    );
                  }
                }
              : null, // Beri nilai null pada onPressed untuk menonaktifkan tombol
          child: const Text('Tukar'),
        ),
      ),
    );
  }
}