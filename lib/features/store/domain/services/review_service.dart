import '../../data/models/review_model.dart';

class ReviewService {
  static List<Review> _dummyReviews = [
    Review(
      id: 'r1',
      productId: 'p1',
      username: 'Andi Gautama',
      avatarInitial: 'A',
      rating: 5.0,
      comment: 'Sepatunya geloooo keren banget, nyaman dipakai pas lari. Pengiriman juga cepat!',
      date: DateTime(2025, 10, 2),
    ),
    Review(
      id: 'r2',
      productId: 'p1',
      username: 'Kanye West',
      avatarInitial: 'K',
      rating: 4.0,
      comment: 'Kualitasnya bagus, tapi ukurannya sedikit lebih kecil dari biasanya. Saranku, naikin satu ukuran.',
      date: DateTime(2025, 9, 28),
    ),
    Review(
      id: 'r3',
      productId: 'p10',
      username: 'Cindy Lung Lung',
      avatarInitial: 'C',
      rating: 4.5,
      comment: 'Bahannya enak, suka banget sama modelnya. Pas di badan!',
      date: DateTime(2025, 10, 1),
    ),
     Review(
      id: 'r5',
      productId: 'p8',
      username: 'Eko Johaneshuu',
      avatarInitial: 'E',
      rating: 5.0,
      comment: 'HPnya cangihh coyyy, kameranya jernih. Cocok buat gaming dan foto-foto.',
      date: DateTime(2025, 10, 3),
    ),
    Review(
      id: 'r7',
      productId: 'p19',
      username: 'Gita diva',
      avatarInitial: 'G',
      rating: 5.0,
      comment: 'Suaranya sejernih air mineral, bass-nya mantap. Noise cancelling-nya juga berfungsi baik.',
      date: DateTime(2025, 10, 4),
    ),
     Review(
      id: 'r6',
      productId: 'p4',
      username: 'Farhan Kuliner',
      avatarInitial: 'F',
      rating: 5.0,
      comment: 'Burgernya juara! Isiannya tebel, rasanya pas, ga terlalu pedas. Pasti pesen lagi!',
      date: DateTime(2025, 10, 1),
    ),
    Review(
      id: 'r8',
      productId: 'p11',
      username: 'Harry Pustaka',
      avatarInitial: 'H',
      rating: 5.0,
      comment: 'Ceritanya seru banget, bikin penasaran sampai akhir. Kualitas cetakannya juga bagus.',
      date: DateTime(2025, 10, 5),
    ),
    Review(
      id: 'r9',
      productId: 'p11',
      username: 'Irma Pembaca',
      avatarInitial: 'I',
      rating: 4.0,
      comment: 'Plot twistnya dapet banget! Recommended buat penggemar sci-fi.',
      date: DateTime(2025, 10, 4),
    ),
  ];

  static void addReview(Review newReview) {
    _dummyReviews.insert(0, newReview);
  }

  static List<Review> getReviewsForProduct(String productId) {
    return _dummyReviews.where((review) => review.productId == productId).toList();
  }
}
