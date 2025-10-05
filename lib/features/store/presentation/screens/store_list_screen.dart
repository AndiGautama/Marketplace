import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/store/data/models/store_model.dart';
import 'package:marketplace2/features/store/data/repositories/mock_store_repository.dart';

class StoreListScreen extends StatefulWidget {
  final String categoryName;
  const StoreListScreen({super.key, required this.categoryName});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  late Future<List<StoreModel>> _storesFuture;
  final MockStoreRepository storeRepository = MockStoreRepository();

  // 🎨 Warna Tema ABU-ABU GELAP (Lokal)
  final Color darkPrimary = Colors.grey.shade900; // Warna Aksi/Primer Abu-abu gelap
  final Color lightBackground = Colors.grey.shade100; // Background ABU-ABU MUDA
  final Color appBarBackground = Colors.grey.shade50; // Background AppBar ABU-ABU SANGAT TERANG
  final Color cardBackground = Colors.white;
  final Color cardBorderGrey = Colors.grey.shade400; // Border Abu-abu gelap halus
  final Color secondaryText = Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    _storesFuture = storeRepository.getStoresByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground, // Background ABU-ABU MUDA
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: darkPrimary, // Teks judul Abu-abu gelap
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarBackground, // Background AppBar ABU-ABU SANGAT TERANG
        foregroundColor: darkPrimary, // Ikon kembali Abu-abu gelap
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: FutureBuilder<List<StoreModel>>(
        future: _storesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: darkPrimary), // Loading Abu-abu gelap
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada toko dalam kategori ini.',
                style: TextStyle(color: secondaryText),
              ),
            );
          }
          final stores = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return _buildStoreCard(context, store);
            },
          );
        },
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, StoreModel store) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: cardBackground, // Card putih
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Border Abu-abu gelap halus
        side: BorderSide(
          color: cardBorderGrey, 
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => GoRouter.of(context).push('/stores/${store.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Toko
            Image.asset(
              store.bannerUrl,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey.shade200, // Placeholder Abu-abu Muda
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: darkPrimary, // Ikon Abu-abu gelap
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                store.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: darkPrimary, // Teks Abu-abu gelap
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}