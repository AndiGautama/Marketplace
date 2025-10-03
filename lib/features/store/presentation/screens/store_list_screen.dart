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
  final MockStoreRepository storeRepository = MockStoreRepository();
  late Future<List<StoreModel>> _storesFuture;

  @override
  void initState() {
    super.initState();
    _storesFuture = storeRepository.getStoresByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- PERUBAHAN DI SINI ---
        // Kita tidak perlu tombol manual lagi, AppBar akan membuatnya secara otomatis
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => context.pop(),
        // ),
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder<List<StoreModel>>(
        future: _storesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada toko di kategori ini.'));
          }

          final stores = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.push('/stores/${store.id}');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 120,
                        color: Colors.grey.shade300,
                        child: Center(child: Text('${store.name} Banner')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(store.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}