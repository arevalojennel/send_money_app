import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel(
      {required super.id, required super.amount, required super.timestamp});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
