import 'package:flutter/foundation.dart';

class UserStats {
  final int orderCount;
  final int reviewCount;
  final double monthlySpending;

  UserStats({this.orderCount = 0, this.reviewCount = 0, this.monthlySpending = 0.0});
}

class UserStatsService {
  UserStatsService._privateConstructor();
  static final UserStatsService instance = UserStatsService._privateConstructor();

  final ValueNotifier<UserStats> stats = ValueNotifier(UserStats());

  void incrementReviewCount() {
    stats.value = UserStats(
      orderCount: stats.value.orderCount,
      reviewCount: stats.value.reviewCount + 1,
      monthlySpending: stats.value.monthlySpending,
    );
  }

  void addOrder(double amount) {
    stats.value = UserStats(
      orderCount: stats.value.orderCount + 1,
      reviewCount: stats.value.reviewCount,
      monthlySpending: stats.value.monthlySpending + amount,
    );
  }

  void reset() {
    stats.value = UserStats();
  }
}