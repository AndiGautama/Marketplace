import 'package:shared_preferences/shared_preferences.dart';

class WalletRepository {
  Future<Map<String, num>> loadWallet(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final balanceKey = '${userEmail}_balance';
    final pointsKey = '${userEmail}_points';

    final double balance = prefs.getDouble(balanceKey) ?? 0.0;
    final int points = prefs.getInt(pointsKey) ?? 0;
    return {'balance': balance, 'points': points};
  }

  Future<void> saveWallet({
    required String userEmail,
    required double balance,
    required int points,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final balanceKey = '${userEmail}_balance';
    final pointsKey = '${userEmail}_points';

    await prefs.setDouble(balanceKey, balance);
    await prefs.setInt(pointsKey, points);
  }
}