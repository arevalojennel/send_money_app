import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../../core/error/failures.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, Transaction>> sendMoney(double amount);
}
