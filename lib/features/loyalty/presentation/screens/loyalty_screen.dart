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
        title: const Text('Tukar Poin'),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, walletState) {
          if (walletState is WalletLoaded) {
            return Column(
              children: [
                _buildPointsHeader(context, walletState.points),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.deepPurpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          const Text('Poin Kamu Saat Ini', style: TextStyle(fontSize: 18, color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            '$points Poin',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, RewardModel reward, bool canRedeem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.card_giftcard, color: Theme.of(context).primaryColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reward.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${reward.pointCost} Poin', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: canRedeem
                  ? () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthSuccess) {
                        final transaction = TransactionModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: TransactionType.pointRedemption,
                          description: 'Tukar: ${reward.name}',
                          amountChange: 0,
                          pointsChange: -reward.pointCost,
                          date: DateTime.now(),
                        );
                        context
                            .read<HistoryRepository>()
                            .addTransaction(authState.user.email, transaction);

                        context.read<WalletBloc>().add(RedeemPoints(
                              pointsToSubtract: reward.pointCost,
                              userEmail: authState.user.email,
                            ));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Berhasil menukar ${reward.name}!'),
                              backgroundColor: Colors.green),
                        );
                      }
                    }
                  : null,
              child: const Text('Tukar'),
            ),
          ],
        ),
      ),
    );
  }
}