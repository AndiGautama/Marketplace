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

  // 🎨 Warna Tema Abu-abu
  final Color primaryGrey = Colors.grey.shade800;
  final Color backgroundGrey = Colors.grey.shade100;
  final Color appBarBackground = Colors.grey.shade200;
  final Color cardBackground = Colors.white;

  @override
  void initState() {
    super.initState();
    _storesFuture = storeRepository.getStoresByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: primaryGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarBackground,
        foregroundColor: primaryGrey,
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: FutureBuilder<List<StoreModel>>(
        future: _storesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryGrey),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada toko dalam kategori ini.',
                style: TextStyle(color: Colors.grey.shade600),
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
      color: cardBackground,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade300,
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
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey,
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
                  color: primaryGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
