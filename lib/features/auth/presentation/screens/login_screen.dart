import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // 🎨 Definisi Warna Tema ABU-ABU GELAP (Lokal)
    final Color darkBackground = Colors.grey.shade600; // Background gelap
    final Color primaryDark = Colors.grey.shade900; // Warna utama (Teks & Ikon)
    final Color inputFillColor = Colors.white; // Input field tetap putih
    final Color buttonColor = Colors.grey.shade300; // Tombol abu-abu muda
    final Color inputBorderColor = Colors.grey.shade400; // Warna border input

    return Scaffold(
      backgroundColor: darkBackground, // Background ABU-ABU GELAP
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/'); // Navigasi ke Home jika sukses
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ikon Toko
                    Icon(Icons.store,
                        size: 80, color: primaryDark), // Ikon Abu-abu Gelap
                    const SizedBox(height: 16),
                    // Judul Aplikasi
                    Text(
                      'Marketplace',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        color: primaryDark, // Teks Abu-abu Gelap
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Input Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email or Phone',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.person, color: primaryDark),
                        filled: true,
                        fillColor: inputFillColor,
                        // Styling border baru
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
                    const SizedBox(height: 16),
                    // Input Password
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock, color: primaryDark),
                        filled: true,
                        fillColor: inputFillColor,
                        // Styling border baru
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
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    // Tombol Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: primaryDark), // Teks Abu-abu Gelap
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol Login
                    state is AuthLoading
                        ? Center(child: CircularProgressIndicator(color: primaryDark))
                        : ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginButtonPressed(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor, // Tombol abu-abu muda
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0, // Menghilangkan elevasi untuk tampilan clean
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(color: primaryDark), // Teks tombol Abu-abu Gelap
                            ),
                          ),
                    const SizedBox(height: 16),
                    // Teks 'or'
                    Text('or',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryDark)), // Teks Abu-abu Gelap
                    // Tombol Create an account
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: Text(
                        'Create an account',
                        style: TextStyle(color: primaryDark), // Teks Abu-abu Gelap
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}