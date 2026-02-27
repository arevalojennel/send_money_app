import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app/domain/entities/transaction.dart';
import 'package:send_money_app/domain/repositories/transaction_repository.dart';
import 'package:send_money_app/domain/usecases/send_money.dart';
import 'package:send_money_app/core/error/failures.dart';

import 'send_money_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late SendMoney useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = SendMoney(mockRepository);
  });

  final tTransaction =
      Transaction(id: 1, amount: 100, timestamp: DateTime.now());

  test('should send money and return transaction when amount is positive',
      () async {
    when(mockRepository.sendMoney(100))
        .thenAnswer((_) async => Right(tTransaction));

    final result = await useCase(100);

    expect(result, Right(tTransaction));
    verify(mockRepository.sendMoney(100));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return InvalidAmountFailure when amount <= 0', () async {
    final result = await useCase(-5);

    expect(result, isA<Left<Failure, Transaction>>());
    expect((result as Left).value, isA<InvalidAmountFailure>());
    verifyZeroInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    when(mockRepository.sendMoney(100))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(100);

    expect(result, isA<Left<Failure, Transaction>>());
    expect((result as Left).value, isA<ServerFailure>());
    verify(mockRepository.sendMoney(100));
    verifyNoMoreInteractions(mockRepository);
  });
}
