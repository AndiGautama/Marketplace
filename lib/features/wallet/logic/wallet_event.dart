part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object> get props => [];
}

class LoadWallet extends WalletEvent {
  final String userEmail;
  const LoadWallet({required this.userEmail});
  @override
  List<Object> get props => [userEmail];
}

class TopUpBalance extends WalletEvent {
  final double amount;
  final String userEmail;
  const TopUpBalance({required this.amount, required this.userEmail});
  @override
  List<Object> get props => [amount, userEmail];
}

// Event baru yang menggantikan SubtractBalance dan AddPoints
class ProcessPurchase extends WalletEvent {
  final double amountToSubtract;
  final int pointsToAdd;
  final String userEmail;

  const ProcessPurchase({
    required this.amountToSubtract,
    required this.pointsToAdd,
    required this.userEmail,
  });

  @override
  List<Object> get props => [amountToSubtract, pointsToAdd, userEmail];
}

// Event baru untuk menukar poin
class RedeemPoints extends WalletEvent {
  final int pointsToSubtract;
  final String userEmail;
  const RedeemPoints({required this.pointsToSubtract, required this.userEmail});
  @override
  List<Object> get props => [pointsToSubtract, userEmail];
}

// Event baru untuk mereset wallet ke kondisi awal
class ResetWallet extends WalletEvent {}