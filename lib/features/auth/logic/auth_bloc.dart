import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace2/features/auth/data/models/user_model.dart';
import 'package:marketplace2/features/auth/data/repositories/local_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalAuthRepository _authRepository;

  AuthBloc({required LocalAuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<ForgotPasswordResetRequested>(_onForgotPasswordResetRequested);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  // Handler untuk memeriksa status otentikasi saat aplikasi dimulai
  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    final bool loggedIn = await _authRepository.isLoggedIn();
    if (loggedIn) {
      // Jika sudah login, ambil data pengguna dan kirim state sukses
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user: user));
      }
    }
  }

  // Handler untuk proses login
  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(email: event.email, password: event.password);
      // Setelah login berhasil, ambil data pengguna yang baru saja login
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        // Kasus jika data pengguna gagal diambil setelah login
        emit(const AuthFailure(error: 'Gagal mendapatkan data pengguna.'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Handler untuk proses registrasi
  Future<void> _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.register(
          fullName: event.fullName, email: event.email, password: event.password);
      // Setelah registrasi, langsung loginkan pengguna
      await _authRepository.login(email: event.email, password: event.password);
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthFailure(error: 'Gagal mendapatkan data pengguna setelah registrasi.'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Handler untuk permintaan reset password
  Future<void> _onForgotPasswordResetRequested(
      ForgotPasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(email: event.email);
      emit(AuthPasswordResetEmailSent());
    } catch (e) {
      emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Handler untuk logout
  Future<void> _onLogoutButtonPressed(
      LogoutButtonPressed event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(AuthLoggedOut());
  }
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}