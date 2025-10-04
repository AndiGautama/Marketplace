import '../../data/models/review_model.dart';

class ReviewService {
  // Data ulasan dummy dengan ID produk yang sudah disesuaikan
  static final List<Review> _dummyReviews = [
    // --- Ulasan untuk TOKO SEPATU (Produk ID: 'p1') ---
    Review(
      id: 'r1',
      productId: 'p1', // Sesuai dengan 'Sepatu Lari Cepat'
      username: 'Andi Gautama',
      avatarInitial: 'A',
      rating: 5.0,
      comment: 'Sepatunya geloooo keren banget, nyaman dipakai pas lari. Pengiriman juga cepat!',
      date: DateTime(2025, 10, 2),
    ),
    Review(
      id: 'r2',
      productId: 'p1', // Sesuai dengan 'Sepatu Lari Cepat'
      username: 'Kanye West',
      avatarInitial: 'K',
      rating: 4.0,
      comment: 'Kualitasnya bagus, tapi ukurannya sedikit lebih kecil dari biasanya. Saranku, naikin satu ukuran.',
      date: DateTime(2025, 9, 28),
    ),

    // --- Ulasan untuk TOKO FASHION (Produk ID: 'p10') ---
    Review(
      id: 'r3',
      productId: 'p10', // Sesuai dengan 'Kemeja Lengan Panjang'
      username: 'Cindy Lung Lung',
      avatarInitial: 'C',
      rating: 4.5,
      comment: 'Bahannya enak, suka banget sama modelnya. Pas di badan!',
      date: DateTime(2025, 10, 1),
    ),
    
    // --- Ulasan untuk TOKO GADGET (Produk ID: 'p8' & 'p19') ---
     Review(
      id: 'r5',
      productId: 'p8', // Sesuai dengan 'Smartphone Terbaru'
      username: 'Eko Johaneshuu',
      avatarInitial: 'E',
      rating: 5.0,
      comment: 'HPnya cangihh coyyy, kameranya jernih. Cocok buat gaming dan foto-foto.',
      date: DateTime(2025, 10, 3),
    ),
    Review(
      id: 'r7',
      productId: 'p19', // Ulasan untuk produk baru 'Wireless Earbuds Pro'
      username: 'Gita diva',
      avatarInitial: 'G',
      rating: 5.0,
      comment: 'Suaranya sejernih air mineral, bass-nya mantap. Noise cancelling-nya juga berfungsi baik.',
      date: DateTime(2025, 10, 4),
    ),

    // --- Ulasan untuk TOKO MAKANAN (Produk ID: 'p4') ---
     Review(
      id: 'r6',
      productId: 'p4', // Sesuai dengan 'Burger Spesial Keju'
      username: 'Farhan Kuliner',
      avatarInitial: 'F',
      rating: 5.0,
      comment: 'Burgernya juara! Isiannya tebel, rasanya pas, ga terlalu pedas. Pasti pesen lagi!',
      date: DateTime(2025, 10, 1),
    ),

    // --- Ulasan untuk TOKO BUKU (Andi Media - Produk ID: 'p11') ---
    Review(
      id: 'r8',
      productId: 'p11', // Sesuai dengan 'Novel Fiksi Ilmiah'
      username: 'Harry Pustaka',
      avatarInitial: 'H',
      rating: 5.0,
      comment: 'Ceritanya seru banget, bikin penasaran sampai akhir. Kualitas cetakannya juga bagus.',
      date: DateTime(2025, 10, 5),
    ),
    Review(
      id: 'r9',
      productId: 'p11', // Sesuai dengan 'Novel Fiksi Ilmiah'
      username: 'Irma Pembaca',
      avatarInitial: 'I',
      rating: 4.0,
      comment: 'Plot twistnya dapet banget! Recommended buat penggemar sci-fi.',
      date: DateTime(2025, 10, 4),
    ),
  ];

  // Fungsi ini tetap sama, mengambil ulasan berdasarkan ID produk
  List<Review> getReviewsForProduct(String productId) {
    return _dummyReviews.where((review) => review.productId == productId).toList();
  }
}

