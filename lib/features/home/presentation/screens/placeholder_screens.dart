import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // Menambahkan tombol kembali secara otomatis jika masuk dari halaman lain
        automaticallyImplyLeading: true, 
      ),
      body: Center(
        child: Text(
          'Halaman $title',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}