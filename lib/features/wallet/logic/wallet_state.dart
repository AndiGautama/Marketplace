part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoaded extends WalletState {
  final double balance;
  final int points;

  const WalletLoaded({required this.balance, required this.points});

  @override
  List<Object> get props => [balance, points];
}