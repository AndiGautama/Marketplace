import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Toko Sepatu', 'icon': Icons.shopify_outlined},
    {'name': 'Toko Film', 'icon': Icons.theaters},
    {'name': 'Toko Makanan', 'icon': Icons.fastfood_outlined},
    {'name': 'Toko Fashion', 'icon': Icons.checkroom_outlined},
    {'name': 'Toko Gadget', 'icon': Icons.phone_android},
    {'name': 'Toko Buku', 'icon': Icons.menu_book},
  ];

  @override
  Widget build(BuildContext context) {
    // 🎨 Definisi Warna Tema ABU-ABU GELAP (Lokal)
    final Color darkPrimary = Colors.grey.shade900;    // Warna utama (ikon/teks)
    final Color lightBackground = Colors.grey.shade200; // Background halaman
    final Color appBarBackground = Colors.grey.shade100; // Background AppBar
    final Color cardBorderGrey = Colors.grey.shade400;  // Border Card
    final Color cardBackground = Colors.white; 
    
    return Scaffold(
      backgroundColor: lightBackground, // Background ABU-ABU TERANG
      appBar: AppBar(
        title: Text(
          'Kategori Toko',
          style: TextStyle(color: darkPrimary, fontWeight: FontWeight.bold), // Teks judul Abu-abu gelap
        ),
        backgroundColor: appBarBackground, // Background AppBar ABU-ABU SANGAT TERANG
        foregroundColor: darkPrimary, // Warna ikon kembali Abu-abu gelap
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              color: cardBackground, // Card putih
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                // Border Abu-abu gelap
                side: BorderSide(color: cardBorderGrey) 
              ),
              child: InkWell(
                onTap: () {
                  context.push('/categories/${category['name']}');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ikon Abu-abu gelap
                    Icon(category['icon'], size: 48, color: darkPrimary),
                    const SizedBox(height: 12),
                    Text(
                      category['name'],
                      // Teks Abu-abu gelap
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkPrimary), 
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}