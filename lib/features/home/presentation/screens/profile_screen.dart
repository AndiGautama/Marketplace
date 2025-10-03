import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/wallet/logic/wallet_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil Saya'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return _buildLoggedInView(context, state);
          } else {
            return _buildGuestView(context);
          }
        },
      ),
    );
  }

  Widget _buildLoggedInView(BuildContext context, AuthSuccess authState) {
    // --- PERINTAH DEBUGGING ---
    // Baris ini akan mencetak nama pengguna ke Debug Console saat halaman ini dibuat.
    debugPrint("--- Membangun Halaman Profil untuk pengguna: '${authState.user.fullName}' ---");
    // -------------------------

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Text(
              authState.user.fullName.isNotEmpty ? authState.user.fullName[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            authState.user.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            authState.user.email,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, walletState) {
              if (walletState is WalletLoaded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWalletInfo('Saldo', AppFormatter.formatRupiah(walletState.balance)),
                    _buildWalletInfo('Poin', '${walletState.points} Poin'),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutButtonPressed());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.login, size: 64, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Silahkan login untuk melihat profil, saldo, dan poin Anda',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Login atau Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}