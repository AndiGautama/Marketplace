import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/app/routes/main_shell.dart';
import 'package:marketplace2/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:marketplace2/features/auth/presentation/screens/login_screen.dart';
import 'package:marketplace2/features/auth/presentation/screens/register_screen.dart';
import 'package:marketplace2/features/cart/presentation/screens/cart_screen.dart';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:marketplace2/features/history/presentation/screens/history_screen.dart';
import 'package:marketplace2/features/home/presentation/screens/category_screen.dart';
import 'package:marketplace2/features/home/presentation/screens/home_screen.dart';
import 'package:marketplace2/features/home/presentation/screens/profile_screen.dart';
import 'package:marketplace2/features/home/presentation/screens/search_screen.dart';
import 'package:marketplace2/features/loyalty/presentation/screens/loyalty_screen.dart';
import 'package:marketplace2/features/store/presentation/screens/store_list_screen.dart';
import 'package:marketplace2/features/store/presentation/screens/store_page_screen.dart';
import 'package:marketplace2/features/wallet/presentation/screens/topup_screen.dart';

// Kunci global untuk navigator, berguna untuk akses di luar konteks widget jika diperlukan.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // Aplikasi akan dimulai dari Halaman Home untuk mode "Tamu"
    initialLocation: '/',
    routes: [
      // Rute-rute ini berada di luar ShellRoute, jadi tidak akan ada bottom navigation bar.
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
       GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
       GoRoute(
        path: '/history/:type',
        builder: (context, state) {
          final typeName = state.pathParameters['type']!;
          // Konversi nama string dari URL kembali menjadi enum TransactionType
          final filter = TransactionType.values.byName(typeName);
          return HistoryScreen(filter: filter);
        },
      ),
       // Rute untuk Halaman Daftar Toko
      GoRoute(
        path: '/categories/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return StoreListScreen(categoryName: categoryName);
        },
      ),
       // Rute untuk Halaman Toko Spesifik
      GoRoute(
        path: '/stores/:storeId',
        builder: (context, state) {
          final storeId = state.pathParameters['storeId']!;
          return StorePageScreen(storeId: storeId);
        },
      ),

      // ShellRoute membungkus semua rute di dalamnya dengan widget MainShell.
      // Ini memastikan BottomAppBar selalu terlihat di halaman-halaman ini.
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // Rute untuk Halaman Home
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            // Sub-rute untuk Halaman Kategori, dapat diakses dari Home
            routes: [
              GoRoute(
                path: 'categories', // URL akan menjadi /categories
                builder: (context, state) => const CategoryScreen(),
              ),
            ],
          ),
          // Rute untuk Halaman Keranjang
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          // Rute untuk Halaman Tambah (Top-Up)
          GoRoute(
            path: '/add',
            builder: (context, state) => const TopUpScreen(),
          ),
          // Rute untuk Halaman Profil
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          // Rute untuk Halaman Loyalty
          GoRoute(
            path: '/loyalty',
            builder: (context, state) => const LoyaltyScreen(),
          ),
        ],
      ),
    ],
  );
}