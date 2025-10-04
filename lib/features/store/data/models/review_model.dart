class Review {
  final String id;
  final String productId;
  final String username;
  final String avatarInitial; // Huruf pertama dari nama untuk avatar
  final double rating; // Rating dari 1.0 sampai 5.0
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.productId,
    required this.username,
    required this.avatarInitial,
    required this.rating,
    required this.comment,
    required this.date,
  });
}