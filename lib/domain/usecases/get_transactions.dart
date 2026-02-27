import 'package:dartz/dartz.dart';
import '../repositories/transaction_repository.dart';
import '../entities/transaction.dart';
import '../../core/error/failures.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call() async {
    return await repository.getTransactions();
  }
}
