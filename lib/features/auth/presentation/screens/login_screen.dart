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

    return Scaffold(
      backgroundColor: Colors.grey[600], // 🔹 Background abu-abu
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
                    Icon(Icons.store,
                        size: 80, color: Colors.black), // 🔹 hitam biar kontras
                    const SizedBox(height: 16),
                    const Text(
                      'Marketplace',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32, // 🔹 lebih besar biar mirip gambar
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email or Phone',
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white, // 🔹 kotak input putih
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30)), // oval
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white, // 🔹 kotak input putih
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30)), // oval
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black), // 🔹 hitam
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginButtonPressed(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey[300], // 🔹 tombol abu-abu muda
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30), // oval
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.black), // 🔹 teks hitam
                            ),
                          ),
                    const SizedBox(height: 16),
                    const Text('or',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black)), // 🔹 hitam
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text(
                        'Create an account',
                        style: TextStyle(color: Colors.black), // 🔹 hitam
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
