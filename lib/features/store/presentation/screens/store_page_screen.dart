import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace2/core/utils/formatter.dart';
import 'package:marketplace2/features/cart/logic/cart_bloc.dart';
import 'package:marketplace2/features/store/data/models/product_model.dart';
import 'package:marketplace2/features/store/data/models/store_model.dart';
import 'package:marketplace2/features/store/data/repositories/mock_store_repository.dart';
import '../widgets/review_widgets.dart';
import '../../domain/services/review_service.dart';
import '../../data/models/review_model.dart';
import 'package:marketplace2/features/home/domain/services/user_stats_service.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';

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

  double _newRating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  final Color primaryGrey = Colors.grey.shade800;
  final Color backgroundGrey = Colors.grey.shade100;
  final Color cardBackground = Colors.white;

  @override
  void initState() {
    super.initState();
    _storeFuture = storeRepository.getStoreById(widget.storeId);
    _productsFuture = storeRepository.getProductsByStoreId(widget.storeId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview(String productId) {
    if (_newRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap berikan rating bintang.'), backgroundColor: Colors.red),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    String username = 'Pengguna';
    String avatarInitial = 'P';

    if (authState is AuthSuccess) {
      username = authState.user.fullName;
      if (username.isNotEmpty) {
        avatarInitial = username[0].toUpperCase();
      }
    }

    final newReview = Review(
      id: DateTime.now().toString(),
      productId: productId,
      username: username,
      avatarInitial: avatarInitial,
      rating: _newRating,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    ReviewService.addReview(newReview);
    UserStatsService.instance.incrementReviewCount();

    setState(() {
      _commentController.clear();
      _newRating = 0.0;
      FocusScope.of(context).unfocus();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ulasan berhasil dikirim!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSectionTitle("Produk Kami"),
          _buildProductGrid(),
          _buildSectionTitle("Ulasan Produk"),
          _buildReviewSection(),
          _buildAddReviewFormSliver(),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      backgroundColor: primaryGrey,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: FutureBuilder<StoreModel>(
          future: _storeFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name, style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.black54)]));
            }
            return const Text('');
          },
        ),
        background: FutureBuilder<StoreModel>(
          future: _storeFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.bannerUrl.isNotEmpty) {
              return Image.asset(
                snapshot.data!.bannerUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error, color: Colors.white)),
              );
            }
            return Container(
              color: primaryGrey.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryGrey
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: primaryGrey)));
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
              childAspectRatio: 0.58,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(context, products[index]),
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      color: cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              product.imageUrl,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey.shade200,
                  child: Center(child: Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey.shade500)),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryGrey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                AppFormatter.formatRupiah(product.price),
                style: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(AddProductToCart(product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} ditambahkan!'), duration: const Duration(seconds: 1), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGrey,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('+ Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final firstProductId = snapshot.data!.first.id;
          final reviews = ReviewService.getReviewsForProduct(firstProductId);

          if (reviews.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Belum ada ulasan untuk produk di toko ini.', style: TextStyle(color: Colors.grey.shade600)),
              )),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ReviewCard(review: reviews[index]),
                childCount: reviews.length,
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildAddReviewFormSliver() {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final firstProductId = snapshot.data!.first.id;

          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(height: 32, color: Colors.grey.shade300),
                  Text(
                    "Tulis Ulasan Anda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGrey),
                  ),
                  const SizedBox(height: 16),
                  Text('Rating Anda:', style: TextStyle(color: primaryGrey)),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () => setState(() => _newRating = index + 1.0),
                        icon: Icon(
                          index < _newRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Bagaimana pendapat Anda tentang produk ini?",
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryGrey, width: 2)),
                      fillColor: Colors.white,
                      filled: true
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _submitReview(firstProductId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGrey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Kirim Ulasan"),
                  ),
                ],
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}