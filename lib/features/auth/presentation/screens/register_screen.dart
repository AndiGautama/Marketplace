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

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Let's Create\nYour Account", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 48),
                      TextFormField(controller: fullNameController, decoration: const InputDecoration(labelText: 'Full Name')),
                      const SizedBox(height: 16),
                      TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email Address'), keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      TextFormField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                      const SizedBox(height: 24),
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                // --- VALIDASI DITAMBAHKAN DI SINI ---
                                final fullName = fullNameController.text.trim();
                                final email = emailController.text.trim();
                                final password = passwordController.text;

                                if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Semua kolom harus diisi.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return; // Hentikan proses jika ada yang kosong
                                }

                                context.read<AuthBloc>().add(RegisterButtonPressed(
                                      fullName: fullName,
                                      email: email,
                                      password: password,
                                    ));
                              },
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                              child: const Text('Sign Up'),
                            ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Have an account?"),
                          TextButton(onPressed: () => context.go('/login'), child: const Text('Sign In')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}