import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace2/features/wallet/data/repositories/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _walletRepository;

  WalletBloc({required WalletRepository walletRepository})
      : _walletRepository = walletRepository,
        super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<TopUpBalance>(_onTopUpBalance);
    on<ProcessPurchase>(_onProcessPurchase);
    on<RedeemPoints>(_onRedeemPoints);
    on<ResetWallet>(_onResetWallet);
  }

  Future<void> _onResetWallet(ResetWallet event, Emitter<WalletState> emit) async {
    emit(const WalletLoaded(balance: 0, points: 0));
  }

  Future<void> _onRedeemPoints(RedeemPoints event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;
      if (currentState.points >= event.pointsToSubtract) {
        final newPoints = currentState.points - event.pointsToSubtract;

        await _walletRepository.saveWallet(
          userEmail: event.userEmail,
          balance: currentState.balance,
          points: newPoints,
        );
        emit(WalletLoaded(balance: currentState.balance, points: newPoints));
      } else {
      }
    }
  }

  Future<void> _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    final walletData = await _walletRepository.loadWallet(event.userEmail);
    emit(WalletLoaded(
      balance: walletData['balance'] as double,
      points: walletData['points'] as int,
    ));
  }

  Future<void> _onTopUpBalance(TopUpBalance event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;
      final newBalance = currentState.balance + event.amount;
      await _walletRepository.saveWallet(
          userEmail: event.userEmail, balance: newBalance, points: currentState.points);
      emit(WalletLoaded(balance: newBalance, points: currentState.points));
    }
  }

  Future<void> _onProcessPurchase(ProcessPurchase event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;

      final newBalance = currentState.balance - event.amountToSubtract;
      final newPoints = currentState.points + event.pointsToAdd;

      await _walletRepository.saveWallet(
        userEmail: event.userEmail,
        balance: newBalance,
        points: newPoints,
      );

      emit(WalletLoaded(balance: newBalance, points: newPoints));
    }
  }
}