import 'package:marketplace2/features/store/data/models/product_model.dart';
import 'package:marketplace2/features/store/data/models/store_model.dart';

class MockStoreRepository {
  // --- DATABASE TOKO ---
  final List<StoreModel> _stores = const [
    // Toko Sepatu
    StoreModel(id: 'store1', name: 'Toko Sepatu Jovian', category: 'Toko Sepatu', bannerUrl: ''),
    // Toko Makanan
    StoreModel(id: 'store3', name: 'Restoran Reva', category: 'Toko Makanan', bannerUrl: ''),
    // Toko Film
    StoreModel(id: 'store4', name: 'Bioskop George', category: 'Toko Film', bannerUrl: ''),
    // Toko Gadget
    StoreModel(id: 'store5', name: 'Andi GadgetIn', category: 'Toko Gadget', bannerUrl: ''),
    // Toko Fashion
    StoreModel(id: 'store6', name: 'Calvin Fashion', category: 'Toko Fashion', bannerUrl: ''),
    // Toko Buku
    StoreModel(id: 'store7', name: 'Andi Media', category: 'Toko Buku', bannerUrl: ''),
  ];

  // --- DATABASE PRODUK ---
  final List<ProductModel> _products = const [
    // Produk Toko Sepatu Jovian
    ProductModel(id: 'p1', storeId: 'store1', name: 'Sepatu Lari Cepat', description: 'Deskripsi...', imageUrl: '', price: 550000),
    ProductModel(id: 'p2', storeId: 'store1', name: 'Sepatu Santai Urban', description: 'Deskripsi...', imageUrl: '', price: 650000),
    // Produk Restoran Reva
    ProductModel(id: 'p4', storeId: 'store3', name: 'Burger Spesial Keju', description: 'Deskripsi...', imageUrl: '', price: 50000),
    ProductModel(id: 'p5', storeId: 'store3', name: 'Paket Nasi Ayam Goreng', description: 'Deskripsi...', imageUrl: '', price: 35000),
    // Produk Bioskop George
    ProductModel(id: 'p6', storeId: 'store4', name: 'Tiket Nonton Reguler', description: 'Deskripsi...', imageUrl: '', price: 45000),
    ProductModel(id: 'p7', storeId: 'store4', name: 'Paket Popcorn & Soda', description: 'Deskripsi...', imageUrl: '', price: 60000),
    // Produk Andi GadgetIn
    ProductModel(id: 'p8', storeId: 'store5', name: 'Smartphone Terbaru', description: 'Deskripsi...', imageUrl: '', price: 8999000),
    ProductModel(id: 'p9', storeId: 'store5', name: 'Powerbank 10000mAh', description: 'Deskripsi...', imageUrl: '', price: 250000),
    // Produk Calvin Fashion
    ProductModel(id: 'p10', storeId: 'store6', name: 'Kemeja Lengan Panjang', description: 'Deskripsi...', imageUrl: '', price: 350000),
    // Produk Andi Media
    ProductModel(id: 'p11', storeId: 'store7', name: 'Novel Fiksi Ilmiah', description: 'Deskripsi...', imageUrl: '', price: 120000),
    ProductModel(id: 'p12', storeId: 'store7', name: 'Buku Self-Improvement', description: 'Deskripsi...', imageUrl: '', price: 150000),
  ];
  
  // Mengambil semua toko yang ada (untuk fitur pencarian)
  Future<List<StoreModel>> getAllStores() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _stores;
  }

  // Mengambil daftar toko berdasarkan kategori
  Future<List<StoreModel>> getStoresByCategory(String categoryName) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading
    return _stores.where((store) => store.category == categoryName).toList();
  }

  // Mengambil detail satu toko
  Future<StoreModel> getStoreById(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _stores.firstWhere((store) => store.id == storeId);
  }

  // Mengambil produk berdasarkan ID toko
  Future<List<ProductModel>> getProductsByStoreId(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products.where((product) => product.storeId == storeId).toList();
  }
}