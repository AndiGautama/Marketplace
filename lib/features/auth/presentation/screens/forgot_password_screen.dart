import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    // 🎨 Definisi Warna Tema ABU-ABU GELAP (Lokal)
    final Color darkBackground = Colors.grey.shade600; // Background gelap
    final Color primaryDark = Colors.grey.shade900; // Warna utama (Teks & Ikon)
    final Color inputFillColor = Colors.white; // Input field tetap putih
    final Color buttonColor = Colors.grey.shade300; // Tombol abu-abu muda
    final Color inputBorderColor = Colors.grey.shade400; // Warna border input
    final Color secondaryText = Colors.black87; 

    return Scaffold(
      backgroundColor: darkBackground, // Background ABU-ABU GELAP
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryDark, // Ikon kembali Abu-abu gelap
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
                Text(
                  'Forgot\nPassword?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    color: primaryDark, // Teks utama Abu-abu gelap
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "No worries, we'll send you reset instructions",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: secondaryText), // Teks sekunder
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.email, color: primaryDark), // Ikon Abu-abu gelap
                    filled: true,
                    fillColor: inputFillColor, // Kotak input putih
                    // Styling border yang dirapikan
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: inputBorderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: inputBorderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: primaryDark, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 32),
                state is AuthLoading
                    ? Center(child: CircularProgressIndicator(color: primaryDark)) // Loader Abu-abu gelap
                    : ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                              ForgotPasswordResetRequested(
                                  email: emailController.text));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor, // Tombol abu-abu muda
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0, // Menghilangkan elevasi
                        ),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(color: primaryDark), // Teks tombol Abu-abu gelap
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: primaryDark), // Teks tombol Abu-abu gelap
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