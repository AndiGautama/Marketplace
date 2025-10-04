import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[600], // 🔹 Background abu-abu
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Instruksi reset password terkirim!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/login'); // Kembali ke login setelah notifikasi
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forgot\nPassword?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    color: Colors.black, // 🔹 hitam
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No worries, we'll send you reset instructions",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87), // 🔹 abu tua
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white, // 🔹 kotak input putih
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)), // oval
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 32),
                state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                              ForgotPasswordResetRequested(
                                  email: emailController.text));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300], // 🔹 tombol abu-abu muda
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(color: Colors.black), // 🔹 teks hitam
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.black), // 🔹 teks hitam
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
