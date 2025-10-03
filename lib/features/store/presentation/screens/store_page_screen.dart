import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/cart/logic/cart_bloc.dart';
import 'package:marketplace2/features/store/data/models/product_model.dart';
import 'package:marketplace2/features/store/data/models/store_model.dart';
import 'package:marketplace2/features/store/data/repositories/mock_store_repository.dart';

class StorePageScreen extends StatefulWidget {
  final String storeId;
  const StorePageScreen({super.key, required this.storeId});

  @override
  State<StorePageScreen> createState() => _StorePageScreenState();
}

class _StorePageScreenState extends State<StorePageScreen> {
  final MockStoreRepository storeRepository = MockStoreRepository();
  late Future<StoreModel> _storeFuture;
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _storeFuture = storeRepository.getStoreById(widget.storeId);
    _productsFuture = storeRepository.getProductsByStoreId(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: FutureBuilder<StoreModel>(
                future: _storeFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.name, style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2)]));
                  }
                  return const Text('');
                },
              ),
              background: Container(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: Center(child: Icon(Icons.storefront, size: 80, color: Colors.white.withOpacity(0.7))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Text("Produk Kami", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          FutureBuilder<List<ProductModel>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverFillRemaining(child: Center(child: Text('Toko ini belum memiliki produk.')));
              }

              final products = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return _buildProductCard(context, product);
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            color: Colors.grey.shade200,
            child: Center(child: Icon(Icons.image_outlined, size: 40, color: Colors.grey.shade500)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              // --- PERUBAHAN DI SINI ---
              AppFormatter.formatRupiah(product.price),
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<CartBloc>().add(AddProductToCart(product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} ditambahkan!'), duration: const Duration(seconds: 1), backgroundColor: Colors.green),
                );
              },
              child: const Text('+ Keranjang'),
            ),
          ),
        ],
      ),
    );
  }
}