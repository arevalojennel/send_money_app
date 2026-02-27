import 'package:dartz/dartz.dart';
import '../repositories/transaction_repository.dart';
import '../entities/transaction.dart';
import '../../core/error/failures.dart';

class SendMoney {
  final TransactionRepository repository;

  SendMoney(this.repository);

  Future<Either<Failure, Transaction>> call(double amount) async {
    if (amount <= 0) {
      return Left(InvalidAmountFailure());
    }
    return await repository.sendMoney(amount);
  }
}
