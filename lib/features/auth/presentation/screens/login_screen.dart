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

    final Color darkBackground = Colors.grey.shade600;
    final Color primaryDark = Colors.grey.shade900;
    final Color inputFillColor = Colors.white;
    final Color buttonColor = Colors.grey.shade300;
    final Color inputBorderColor = Colors.grey.shade400;

    return Scaffold(
      backgroundColor: darkBackground,
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.store, size: 80, color: primaryDark),
                    const SizedBox(height: 16),
                    Text(
                      'Marketplace',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email or Phone',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.person, color: primaryDark),
                        filled: true,
                        fillColor: inputFillColor,
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
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: primaryDark.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock, color: primaryDark),
                        filled: true,
                        fillColor: inputFillColor,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: primaryDark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                              backgroundColor: buttonColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(color: primaryDark),
                            ),
                          ),
                    const SizedBox(height: 16),
                    Text('or',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryDark)),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: Text(
                        'Create an account',
                        style: TextStyle(color: primaryDark),
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