import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
        foregroundColor: primaryDark, // Ikon Back Abu-abu Gelap
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/');
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "Let's Create\nYour Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        color: primaryDark, // Teks utama Abu-abu Gelap
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // --- INPUT FULL NAME ---
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.person, color: primaryDark), // Ikon Abu-abu Gelap
                        filled: true,
                        fillColor: inputFillColor,
                        // Styling border rapi
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
                    ),
                    const SizedBox(height: 16),
                    
                    // --- INPUT EMAIL ---
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.email, color: primaryDark), // Ikon Abu-abu Gelap
                        filled: true,
                        fillColor: inputFillColor,
                        // Styling border rapi
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
                    
                    // --- INPUT PASSWORD ---
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock, color: primaryDark), // Ikon Abu-abu Gelap
                        filled: true,
                        fillColor: inputFillColor,
                        // Styling border rapi
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
                    const SizedBox(height: 24),
                    
                    // --- TOMBOL SIGN UP ---
                    state is AuthLoading
                        ? Center(child: CircularProgressIndicator(color: primaryDark))
                        : ElevatedButton(
                            onPressed: () {
                              final fullName = fullNameController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text;

                              if (fullName.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua kolom harus diisi.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              context.read<AuthBloc>().add(
                                    RegisterButtonPressed(
                                      fullName: fullName,
                                      email: email,
                                      password: password,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor, // Tombol abu-abu muda
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: primaryDark), // Teks tombol Abu-abu Gelap
                            ),
                          ),
                    const SizedBox(height: 16),
                    
                    // --- LINK KE LOGIN ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have an account?",
                            style: TextStyle(color: secondaryText)),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: primaryDark), // Teks tombol Abu-abu Gelap
                          ),
                        ),
                      ],
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