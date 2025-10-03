part of 'wallet_bloc.dart';

// Abstract base class untuk semua state
abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object> get props => [];
}

// State awal saat data belum dimuat
class WalletInitial extends WalletState {}

// State ketika data saldo dan poin sudah berhasil dimuat
class WalletLoaded extends WalletState {
  final double balance;
  final int points;

  const WalletLoaded({required this.balance, required this.points});

  @override
  List<Object> get props => [balance, points];
}