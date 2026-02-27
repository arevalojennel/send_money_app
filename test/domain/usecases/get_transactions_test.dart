import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app/domain/entities/transaction.dart';
import 'package:send_money_app/domain/repositories/transaction_repository.dart';
import 'package:send_money_app/domain/usecases/get_transactions.dart';
import 'package:send_money_app/core/error/failures.dart';

import 'get_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late GetTransactions useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactions(mockRepository);
  });

  final tTransactions = [
    Transaction(id: 1, amount: 100, timestamp: DateTime.now()),
    Transaction(id: 2, amount: 200, timestamp: DateTime.now()),
  ];

  test('should get transactions from repository', () async {
    when(mockRepository.getTransactions())
        .thenAnswer((_) async => Right(tTransactions));

    final result = await useCase();

    expect(result, Right(tTransactions));
    verify(mockRepository.getTransactions());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    when(mockRepository.getTransactions())
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase();

    // Check that result is a Left containing a ServerFailure
    expect(result, isA<Left<Failure, List<Transaction>>>());
    expect((result as Left).value, isA<ServerFailure>());
    verify(mockRepository.getTransactions());
    verifyNoMoreInteractions(mockRepository);
  });
}
