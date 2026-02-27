import 'package:dartz/dartz.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../../core/error/failures.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final models = await remoteDataSource.getTransactions();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Transaction>> sendMoney(double amount) async {
    try {
      final model = await remoteDataSource.sendTransaction(amount);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
