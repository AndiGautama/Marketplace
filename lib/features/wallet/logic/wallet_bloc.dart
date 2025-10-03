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
    on<ProcessPurchase>(_onProcessPurchase); // Handler baru untuk pembelian
    on<RedeemPoints>(_onRedeemPoints); // Daftarkan handler baru
    on<ResetWallet>(_onResetWallet); // Daftarkan handler baru
  }
   // Handler baru untuk mereset wallet
  Future<void> _onResetWallet(ResetWallet event, Emitter<WalletState> emit) async {
    // Tidak perlu menyimpan, karena saat login berikutnya akan di-load ulang
    emit(const WalletLoaded(balance: 0, points: 0));
  }
 // Handler baru untuk mengurangi poin
  Future<void> _onRedeemPoints(RedeemPoints event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;
   // Pastikan poin cukup
      if (currentState.points >= event.pointsToSubtract) {
        final newPoints = currentState.points - event.pointsToSubtract;

        await _walletRepository.saveWallet(
          userEmail: event.userEmail,
          balance: currentState.balance,
          points: newPoints,
        );
        emit(WalletLoaded(balance: currentState.balance, points: newPoints));
        } else {
        // Jika poin tidak cukup, kita bisa saja tidak melakukan apa-apa
        // atau emit state error khusus (untuk sekarang kita diamkan)
      }
    }
  }
  // Memuat data wallet dari penyimpanan
  Future<void> _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    final walletData = await _walletRepository.loadWallet(event.userEmail);
    emit(WalletLoaded(
      balance: walletData['balance'] as double,
      points: walletData['points'] as int,
    ));
  }

  // Menangani penambahan saldo
  Future<void> _onTopUpBalance(TopUpBalance event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;
      final newBalance = currentState.balance + event.amount;
      await _walletRepository.saveWallet(
          userEmail: event.userEmail, balance: newBalance, points: currentState.points);
      emit(WalletLoaded(balance: newBalance, points: currentState.points));
    }
  }

  // Menangani proses pembelian (kurangi saldo & tambah poin) dalam satu transaksi
  Future<void> _onProcessPurchase(ProcessPurchase event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;

      // Hitung saldo dan poin baru dalam satu operasi
      final newBalance = currentState.balance - event.amountToSubtract;
      final newPoints = currentState.points + event.pointsToAdd;

      // Simpan kedua nilai yang sudah diperbarui ke penyimpanan
      await _walletRepository.saveWallet(
        userEmail: event.userEmail,
        balance: newBalance,
        points: newPoints,
      );

      // Kirim state baru dengan kedua nilai yang sudah diperbarui
      emit(WalletLoaded(balance: newBalance, points: newPoints));
    }
  }
}