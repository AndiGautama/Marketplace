import 'package:flutter/foundation.dart';

// Model untuk menyimpan data statistik
class UserStats {
  final int orderCount;
  final int reviewCount;
  final double monthlySpending;

  UserStats({this.orderCount = 0, this.reviewCount = 0, this.monthlySpending = 0.0});
}

// Service untuk mengelola state statistik
class UserStatsService {
  // Membuat service ini menjadi Singleton, artinya hanya ada satu instance di seluruh aplikasi
  UserStatsService._privateConstructor();
  static final UserStatsService instance = UserStatsService._privateConstructor();

  // ValueNotifier akan memberitahu widget-widget yang mendengarkan jika ada perubahan data
  final ValueNotifier<UserStats> stats = ValueNotifier(UserStats());

  // Fungsi untuk menambah jumlah ulasan
  void incrementReviewCount() {
    stats.value = UserStats(
      orderCount: stats.value.orderCount,
      reviewCount: stats.value.reviewCount + 1,
      monthlySpending: stats.value.monthlySpending,
    );
  }

  // Fungsi untuk menambah pesanan dan total pengeluaran
  // Ini akan dipanggil dari halaman checkout nanti
  void addOrder(double amount) {
    stats.value = UserStats(
      orderCount: stats.value.orderCount + 1,
      reviewCount: stats.value.reviewCount,
      monthlySpending: stats.value.monthlySpending + amount,
    );
  }
  
  // Fungsi untuk mereset data saat logout
  void reset() {
    stats.value = UserStats();
  }
}