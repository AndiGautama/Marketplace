import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/models/review_model.dart';
import '../../domain/services/review_service.dart';

class AddReviewScreen extends StatefulWidget {
  final ProductModel product;

  const AddReviewScreen({super.key, required this.product});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  final Color primaryGrey = Colors.grey.shade800;
  final Color backgroundGrey = Colors.grey.shade100;
  final Color appBarBackground = Colors.grey.shade200;
  final Color inputBorderColor = Colors.grey.shade400;

  void _submitReview() {
    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap berikan rating bintang terlebih dahulu.'),
          backgroundColor: primaryGrey,
        ),
      );
      return;
    }

    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: widget.product.id,
      username: 'Jovian (Anda)',
      avatarInitial: 'J',
      rating: _rating,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    ReviewService.addReview(newReview);

    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Tulis Ulasan',
          style: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBackground,
        foregroundColor: primaryGrey,
        elevation: 0,
        surfaceTintColor: appBarBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'Produk: ${widget.product.name}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryGrey),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Berikan Rating Anda:',
            style: TextStyle(
                fontSize: 16, color: primaryGrey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
              );
            }),
          ),
          const SizedBox(height: 30),

          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Bagikan pendapatmu tentang produk ini...',
              labelText: 'Komentar Anda',
              labelStyle: TextStyle(color: primaryGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryGrey, width: 2),
              ),
              fillColor: Colors.white,
              filled: true,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Kirim Ulasan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}