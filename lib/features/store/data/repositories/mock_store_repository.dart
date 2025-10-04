import 'package:marketplace2/features/store/data/models/product_model.dart';
import 'package:marketplace2/features/store/data/models/store_model.dart';

class MockStoreRepository {
  // --- DATABASE TOKO ---
  final List<StoreModel> _stores = const [
    // Toko Sepatu
    StoreModel(id: 'store1', name: 'Toko Sepatu Jovian', category: 'Toko Sepatu', bannerUrl: 'assets/images/banner_sepatu.jpg'),
    // Toko Makanan
    StoreModel(id: 'store3', name: 'Restoran Reva', category: 'Toko Makanan', bannerUrl: 'assets/images/banner_makanan.jpg'),
    // Toko Film
    StoreModel(id: 'store4', name: 'George Cinema', category: 'Toko Film', bannerUrl: 'assets/images/banner_film.jpg'),
    // Toko Gadget
    StoreModel(id: 'store5', name: 'Andi GadgetIn', category: 'Toko Gadget', bannerUrl: 'assets/images/banner_gadget.jpg'),
    // Toko Fashion
    StoreModel(id: 'store6', name: 'Calvin Fashion', category: 'Toko Fashion', bannerUrl: 'assets/images/banner_fashion.jpg'),
    // Toko Buku
    StoreModel(id: 'store7', name: 'Andi Media', category: 'Toko Buku', bannerUrl: 'assets/images/banner_buku.jpg'),
  ];

  // --- DATABASE PRODUK ---
  final List<ProductModel> _products = const [
    // Produk Toko Sepatu Jovian (store1)
    ProductModel(id: 'p1', storeId: 'store1', name: 'Sepatu Kalcer', description: 'Deskripsi...', imageUrl: 'assets/images/sepatu1.jpg', price: 550000),
    ProductModel(id: 'p2', storeId: 'store1', name: 'Sepatu Putih', description: 'Deskripsi...', imageUrl: 'assets/images/sepatu3.jpg', price: 650000),
    ProductModel(id: 'p13', storeId: 'store1', name: 'Sepatu Ganteng', description: 'Deskripsi...', imageUrl: 'assets/images/sepatu2.jpg', price: 750000), // BARU
    ProductModel(id: 'p14', storeId: 'store1', name: 'Sepatu Ekin', description: 'Deskripsi...', imageUrl: 'assets/images/sepatu4.jpg', price: 320000), // BARU

    // Produk Restoran Reva (store3)
    ProductModel(id: 'p4', storeId: 'store3', name: 'Burger Spesial Keju', description: 'Deskripsi...', imageUrl: 'assets/images/makanan1.jpg', price: 50000),
    ProductModel(id: 'p5', storeId: 'store3', name: 'Paket Nasi Ayam Goreng', description: 'Deskripsi...', imageUrl: 'assets/images/makanan2.jpg', price: 35000),
    ProductModel(id: 'p15', storeId: 'store3', name: 'Mie Goreng Seafood', description: 'Deskripsi...', imageUrl: 'assets/images/makanan3.jpg', price: 45000), // BARU
    ProductModel(id: 'p16', storeId: 'store3', name: 'Es Teh Manis Jumbo', description: 'Deskripsi...', imageUrl: 'assets/images/makanan4.jpg', price: 10000), // BARU

    // Produk Bioskop George (store4)
    ProductModel(id: 'p6', storeId: 'store4', name: 'Tiket Nonton Reguler', description: 'Deskripsi...', imageUrl: 'assets/images/tiket1.jpg', price: 45000),
    ProductModel(id: 'p7', storeId: 'store4', name: 'Paket Popcorn & Soda', description: 'Deskripsi...', imageUrl: 'assets/images/tiket2.jpg', price: 60000),
    ProductModel(id: 'p17', storeId: 'store4', name: 'Tiket Nonton 4DX', description: 'Deskripsi...', imageUrl: 'assets/images/tiket3.jpg', price: 120000), // BARU
    ProductModel(id: 'p18', storeId: 'store4', name: 'Nachos Saus Keju', description: 'Deskripsi...', imageUrl: 'assets/images/tiket4.jpg', price: 40000), // BARU

    // Produk Andi GadgetIn (store5)
    ProductModel(id: 'p8', storeId: 'store5', name: 'Smartphone Terbaru', description: 'Deskripsi...', imageUrl: 'assets/images/gadget1.jpg', price: 8999000),
    ProductModel(id: 'p9', storeId: 'store5', name: 'Powerbank 10000mAh', description: 'Deskripsi...', imageUrl: 'assets/images/gadget2.jpg', price: 250000),
    ProductModel(id: 'p19', storeId: 'store5', name: 'Wireless Earbuds Pro', description: 'Deskripsi...', imageUrl: 'assets/images/gadget3.jpg', price: 1200000), // BARU
    ProductModel(id: 'p20', storeId: 'store5', name: 'Smartwatch Generasi 5', description: 'Deskripsi...', imageUrl: 'assets/images/gadget4.jpg', price: 3500000), // BARU

    // Produk Calvin Fashion (store6)
    ProductModel(id: 'p10', storeId: 'store6', name: 'Kemeja Lengan Panjang', description: 'Deskripsi...', imageUrl: 'assets/images/fashion1.jpg', price: 350000),
    ProductModel(id: 'p21', storeId: 'store6', name: 'Jaket Denim Klasik', description: 'Deskripsi...', imageUrl: 'assets/images/fashion2.jpg', price: 550000), // BARU
    ProductModel(id: 'p22', storeId: 'store6', name: 'Topi Baseball Logo', description: 'Deskripsi...', imageUrl: 'assets/images/fashion3.jpg', price: 150000), // BARU

    // Produk Andi Media (store7)
    ProductModel(id: 'p11', storeId: 'store7', name: 'Novel Fiksi Ilmiah', description: 'Deskripsi...', imageUrl: 'assets/images/media1.jpg', price: 120000),
    ProductModel(id: 'p12', storeId: 'store7', name: 'Buku Self-Improvement', description: 'Deskripsi...', imageUrl: 'assets/images/media2.jpg', price: 150000),
    ProductModel(id: 'p23', storeId: 'store7', name: 'Komik Aksi Terlaris', description: 'Deskripsi...', imageUrl: 'assets/images/media3.jpg', price: 95000), // BARU
    ProductModel(id: 'p24', storeId: 'store7', name: 'Majalah Desain Interior', description: 'Deskripsi...', imageUrl: 'assets/images/media4.jpg', price: 75000), // BARU
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