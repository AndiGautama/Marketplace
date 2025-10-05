class Review {
  final String id;
  final String productId;
  final String username;
  final String avatarInitial;
  final double rating;
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