import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  const ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  @override
  List<Object> get props => [id];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      storeId: json['storeId'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}