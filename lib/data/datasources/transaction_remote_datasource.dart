import 'dart:convert';
import '../../core/network/api_client.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<TransactionModel> sendTransaction(double amount);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient apiClient;

  static final List<TransactionModel> _localTransactions = [];
  static int _nextId = 101;

  TransactionRemoteDataSourceImpl({required this.apiClient});

  static void clearLocalTransactions() {
    _localTransactions.clear();
    _nextId = 101;
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    List<TransactionModel> apiTransactions = [];

    // Fake API Call  not throwing any error just storing it locally
    try {
      final response = await apiClient.get('posts?userId=1');
      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        apiTransactions = jsonList.map((json) {
          return TransactionModel(
            id: json['id'],
            amount: (json['id'] * 10.0) % 500,
            timestamp: DateTime.now().subtract(Duration(days: json['id'])),
          );
        }).toList();
      }
    } catch (e) {
      print('Failed to fetch transactions from API: $e');
    }

    return [...apiTransactions, ..._localTransactions];
  }

  @override
  Future<TransactionModel> sendTransaction(double amount) async {
    final newTransaction = TransactionModel(
      id: _nextId++,
      amount: amount,
      timestamp: DateTime.now(),
    );
    _localTransactions.add(newTransaction);

    try {
      await apiClient.post(
        'posts',
        body: {
          'title': 'Sent $amount',
          'body': 'amount',
          'userId': 1,
        },
      );
    } catch (e) {
      print('Failed to post transaction to API: $e');
    }

    return newTransaction;
  }
}
