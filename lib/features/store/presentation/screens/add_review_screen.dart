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

  void _submitReview() {
    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harap berikan rating bintang terlebih dahulu.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: widget.product.id,
      username: 'Jovian (Anda)', // Nama pengguna statis untuk contoh
      avatarInitial: 'J',
      rating: _rating,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    // --- PERBAIKAN DI SINI: Panggil fungsi static langsung dari kelasnya ---
    ReviewService.addReview(newReview);

    Navigator.of(context).pop(true); // Kembali dan kirim sinyal 'true'
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tulis Ulasan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Produk: ${widget.product.name}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('Berikan Rating Anda:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
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
          const SizedBox(height: 20),
          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Bagikan pendapatmu tentang produk ini...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
              labelText: 'Komentar Anda',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: const Text('Kirim Ulasan'),
          )
        ],
      ),
    );
  }
}