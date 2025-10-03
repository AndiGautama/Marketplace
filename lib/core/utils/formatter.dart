import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatter {
  static String formatRupiah(double value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(value);
  }
}

// --- KELAS BARU DI BAWAH INI ---
// Formatter ini akan dipasang di TextField
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Ubah teks input menjadi angka
    double value = double.parse(newValue.text.replaceAll('.', ''));

    final formatter = NumberFormat.decimalPattern('id_ID');

    // Format angka tersebut
    String newText = formatter.format(value);

    // Kembalikan teks yang sudah diformat dengan posisi kursor di akhir
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}