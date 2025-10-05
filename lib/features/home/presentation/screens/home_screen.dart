import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/auth/logic/auth_bloc.dart';
import 'package:marketplace2/features/cart/logic/cart_bloc.dart';

class AdBannerModel {
  final String title;
  final String imageUrl;
  final String navigationPath;

  AdBannerModel({
    required this.title,
    required this.imageUrl,
    required this.navigationPath,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Color primaryGrey = Colors.grey.shade800;
  final Color darkAccent = Colors.grey.shade900;
  final Color lightBackground = Colors.grey.shade100;
  final Color appBarBackground = Colors.grey.shade50;

  final Color searchBoxColor = Colors.white;
  final Color textDark = Colors.black87;
  final Color textLight = Colors.grey.shade600;
  final Color cardBackground = Colors.white;

  final List<AdBannerModel> _adBanners = [
    AdBannerModel(
      title: 'Aneka Makanan Lezat!',
      imageUrl: 'assets/images/banner_makanan.jpg',
      navigationPath: '/categories/Toko Makanan',
    ),
    AdBannerModel(
      title: 'Gadget Terbaru 2025',
      imageUrl: 'assets/images/banner_gadget.jpg',
      navigationPath: '/categories/Toko Gadget',
    ),
    AdBannerModel(
      title: 'Fashion Pria & Wanita',
      imageUrl: 'assets/images/banner_fashion.jpg',
      navigationPath: '/categories/Toko Fashion',
    ),
    AdBannerModel(
      title: 'Koleksi Sepatu Keren',
      imageUrl: 'assets/images/banner_sepatu.jpg',
      navigationPath: '/categories/Toko Sepatu',
    ),
    AdBannerModel(
      title: 'Nonton Film Terbaru',
      imageUrl: 'assets/images/banner_film.jpg',
      navigationPath: '/categories/Toko Film',
    ),
    AdBannerModel(
      title: 'Buku & Media Terlengkap',
      imageUrl: 'assets/images/banner_buku.jpg',
      navigationPath: '/categories/Toko Buku',
    ),
  ];

  final List<Map<String, dynamic>> _popularCategories = [
    {'displayName': 'Sepatu', 'categoryName': 'Toko Sepatu', 'icon': Icons.shopify_outlined},
    {'displayName': 'Film', 'categoryName': 'Toko Film', 'icon': Icons.theaters},
    {'displayName': 'Makanan', 'categoryName': 'Toko Makanan', 'icon': Icons.fastfood_outlined},
    {'displayName': 'Gadget', 'categoryName': 'Toko Gadget', 'icon': Icons.phone_android},
    {'displayName': 'Fashion', 'categoryName': 'Toko Fashion', 'icon': Icons.checkroom_outlined},
    {'displayName': 'Buku', 'categoryName': 'Toko Buku', 'icon': Icons.menu_book},
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleProtectedAction(BuildContext context, VoidCallback action) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      action();
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        surfaceTintColor: appBarBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => context.go('/search'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: searchBoxColor,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: primaryGrey),
                const SizedBox(width: 8),
                Text('Cari Apa?', style: TextStyle(color: textLight, fontSize: 16)),
              ],
            ),
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.items.length;
              }
              return Badge(
                label: Text('$itemCount'),
                isLabelVisible: itemCount > 0,
                backgroundColor: primaryGrey,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, color: primaryGrey),
                  onPressed: () {
                    _handleProtectedAction(context, () {
                      context.go('/cart');
                    });
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthSuccess) {
                    return Text(
                      'Selamat Datang,\n${state.user.fullName}!',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkAccent),
                    );
                  }
                  return Text(
                    'SELAMAT DATANG',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkAccent),
                  );
                },
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _adBanners.length,
                    itemBuilder: (context, index) {
                      final banner = _adBanners[index];
                      return _buildAdBanner(context, banner);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_adBanners.length, (index) => _buildDotIndicator(index)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      context,
                      title: 'Market',
                      subtitle: 'Mulai berbelanja',
                      icon: Icons.storefront_outlined,
                      iconColor: darkAccent,
                      onTap: () => _handleProtectedAction(context, () => context.go('/categories')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureCard(
                      context,
                      title: 'Loyalty',
                      subtitle: 'Mulai menukar',
                      icon: Icons.redeem_outlined,
                      iconColor: darkAccent,
                      onTap: () => _handleProtectedAction(context, () => context.push('/loyalty')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Kategori Populer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkAccent)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _popularCategories.length,
                itemBuilder: (context, index) {
                  final category = _popularCategories[index];
                  return _buildCategoryChip(
                    context,
                    name: category['displayName'],
                    icon: category['icon'],
                    onTap: () => _handleProtectedAction(context, () => context.push('/categories/${category['categoryName']}')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? darkAccent : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildAdBanner(BuildContext context, AdBannerModel banner) {
    return GestureDetector(
      onTap: () {
        _handleProtectedAction(context, () {
          context.push(banner.navigationPath);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage(banner.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Text(
            banner.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Color iconColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String name,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
              child: Icon(icon, size: 30, color: darkAccent),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500, color: darkAccent),
            ),
          ],
        ),
      ),
    );
  }
}