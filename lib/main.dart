import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marketplace2/app/routes/app_router.dart';
import 'package:marketplace2/features/auth/data/repositories/local_auth_repository.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/cart/data/repositories/cart_repository.dart';
import 'package:marketplace2/features/cart/logic/cart_bloc.dart';
import 'package:marketplace2/features/history/data/repositories/history_repository.dart';
import 'package:marketplace2/features/wallet/data/repositories/wallet_repository.dart';
import 'package:marketplace2/features/wallet/logic/wallet_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => LocalAuthRepository()),
        RepositoryProvider(create: (context) => WalletRepository()),
        RepositoryProvider(create: (context) => CartRepository()),
        RepositoryProvider(create: (context) => HistoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<LocalAuthRepository>(),
            )..add(CheckAuthStatus()),
          ),
          BlocProvider(
            create: (context) => WalletBloc(
              walletRepository: context.read<WalletRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              cartRepository: context.read<CartRepository>(),
            ),
          ),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<WalletBloc>().add(LoadWallet(userEmail: state.user.email));
              context.read<CartBloc>().add(LoadCart(userEmail: state.user.email));
            } else if (state is AuthLoggedOut) {
              context.read<WalletBloc>().add(ResetWallet());
              context.read<CartBloc>().add(ClearCart());
            }
          },
          child: MaterialApp.router(
            title: 'Marketplace App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                background: Colors.deepPurple.shade50,
                surface: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.deepPurple.shade50,
              appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.deepPurple.shade50,
                foregroundColor: Colors.black,
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.deepPurple.shade100.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
                ),
                hintStyle: TextStyle(color: Colors.deepPurple.shade300),
                labelStyle: TextStyle(color: Colors.deepPurple.shade400),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                ),
              ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
            ),
            routerConfig: AppRouter.router,
          ),
        ),
      ),
    );
  }
}