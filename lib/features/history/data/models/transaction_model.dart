enum TransactionType { purchase, topUp, pointRedemption }

class TransactionModel {
  final String id;
  final TransactionType type;
  final String description;
  final double amountChange;
  final int pointsChange;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.description,
    required this.amountChange,
    required this.pointsChange,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'description': description,
        'amountChange': amountChange,
        'pointsChange': pointsChange,
        'date': date.toIso8601String(),
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'],
        type: TransactionType.values.byName(json['type']),
        description: json['description'],
        amountChange: json['amountChange'],
        pointsChange: json['pointsChange'],
        date: DateTime.parse(json['date']),
      );
}