import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:send_money_app/domain/usecases/get_transactions.dart';
import 'package:send_money_app/domain/entities/transaction.dart';
import 'package:send_money_app/presentation/cubit/transactions/transactions_cubit.dart';
import 'package:send_money_app/core/error/failures.dart';

import 'transactions_cubit_test.mocks.dart';

@GenerateMocks([GetTransactions])
void main() {
  late TransactionsCubit cubit;
  late MockGetTransactions mockGetTransactions;

  setUp(() {
    mockGetTransactions = MockGetTransactions();
    cubit = TransactionsCubit(getTransactionsUseCase: mockGetTransactions);
  });

  group('loadTransactions', () {
    final tTransactions = [
      Transaction(id: 1, amount: 100, timestamp: DateTime.now()),
      Transaction(id: 2, amount: 200, timestamp: DateTime.now()),
    ];

    blocTest<TransactionsCubit, TransactionsState>(
      'emits [TransactionsLoading, TransactionsLoaded] when use case succeeds',
      build: () {
        when(mockGetTransactions())
            .thenAnswer((_) async => Right(tTransactions));
        return cubit;
      },
      act: (cubit) => cubit.loadTransactions(),
      expect: () => [
        isA<TransactionsLoading>(),
        isA<TransactionsLoaded>()
            .having((s) => s.transactions, 'transactions', tTransactions),
      ],
    );

    blocTest<TransactionsCubit, TransactionsState>(
      'emits [TransactionsLoading, TransactionsError] when use case fails',
      build: () {
        when(mockGetTransactions())
            .thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.loadTransactions(),
      expect: () => [
        isA<TransactionsLoading>(),
        isA<TransactionsError>()
            .having((s) => s.message, 'message', 'Failed to load transactions'),
      ],
    );
  });
}
