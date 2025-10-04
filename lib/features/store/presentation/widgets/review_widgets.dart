import 'package:flutter/material.dart';
import '../../domain/services/review_service.dart';
import '../../data/models/review_model.dart';
import 'package:intl/intl.dart';

// Widget untuk menampilkan bintang rating
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  const RatingStars({super.key, required this.rating, this.size = 16.0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating && index == rating.floor())
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}

// Widget untuk menampilkan satu kartu ulasan
class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(review.avatarInitial),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  RatingStars(rating: review.rating),
                ],
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM yyyy').format(review.date),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan seluruh bagian ulasan di halaman produk
class ReviewSection extends StatelessWidget {
  final String productId;
  const ReviewSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final reviews = ReviewService().getReviewsForProduct(productId);

    if (reviews.isEmpty) {
      return const Center(child: Text('Belum ada ulasan untuk produk ini.'));
    }

    // Hitung rata-rata rating
    final double averageRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ulasan Produk (${reviews.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingStars(rating: averageRating, size: 20),
              const SizedBox(width: 8),
              Text(
                '${averageRating.toStringAsFixed(1)} dari 5.0',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const Divider(height: 32),
          // Daftar semua ulasan
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Agar tidak bisa di-scroll di dalam scroll
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewCard(review: reviews[index]);
            },
          ),
        ],
      ),
    );
  }
}
