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
    final Color darkPrimary = Colors.grey.shade900;
    final Color lightBackground = Colors.grey.shade200;
    final Color appBarBackground = Colors.grey.shade100;
    final Color cardBorderGrey = Colors.grey.shade400;
    final Color cardBackground = Colors.white;

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: Text(
          'Kategori Toko',
          style: TextStyle(color: darkPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBackground,
        foregroundColor: darkPrimary,
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
              color: cardBackground,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: cardBorderGrey),
              ),
              child: InkWell(
                onTap: () {
                  context.push('/categories/${category['name']}');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category['icon'], size: 48, color: darkPrimary),
                    const SizedBox(height: 12),
                    Text(
                      category['name'],
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