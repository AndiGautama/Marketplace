import 'dart:convert';
import 'package:marketplace2/features/history/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  Future<List<TransactionModel>> getTransactions(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userEmail}_history';
    final String? historyString = prefs.getString(key);

    if (historyString != null) {
      final List<dynamic> historyJson = jsonDecode(historyString);
      final transactions = historyJson.map((json) => TransactionModel.fromJson(json)).toList();
      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    }
    return [];
  }

  Future<void> addTransaction(String userEmail, TransactionModel transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userEmail}_history';

    final transactions = await getTransactions(userEmail);
    transactions.add(transaction);

    final String historyString = jsonEncode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString(key, historyString);
  }
}