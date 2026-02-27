import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:send_money_app/domain/usecases/send_money.dart';
import 'package:send_money_app/domain/entities/transaction.dart';
import 'package:send_money_app/presentation/cubit/send_money/send_money_cubit.dart';
import 'package:send_money_app/presentation/cubit/home/home_cubit.dart';
import 'package:send_money_app/core/error/failures.dart';

import 'send_money_cubit_test.mocks.dart';

@GenerateMocks([SendMoney, HomeCubit])
void main() {
  late SendMoneyCubit cubit;
  late MockSendMoney mockSendMoney;
  late MockHomeCubit mockHomeCubit;

  setUp(() {
    mockSendMoney = MockSendMoney();
    mockHomeCubit = MockHomeCubit();
    when(mockHomeCubit.state)
        .thenReturn(const HomeState(balance: 500, isBalanceHidden: false));
    cubit = SendMoneyCubit(
        sendMoneyUseCase: mockSendMoney, homeCubit: mockHomeCubit);
  });

  group('submitAmount', () {
    final tTransaction =
        Transaction(id: 1, amount: 100, timestamp: DateTime.now());

    blocTest<SendMoneyCubit, SendMoneyState>(
      'emits [SendMoneyLoading, SendMoneySuccess] when use case succeeds and balance sufficient',
      build: () {
        when(mockSendMoney(100)).thenAnswer((_) async => Right(tTransaction));
        return cubit;
      },
      act: (cubit) => cubit.submitAmount(100),
      expect: () => [
        isA<SendMoneyLoading>(),
        isA<SendMoneySuccess>()
            .having((s) => s.transaction, 'transaction', tTransaction),
      ],
      verify: (_) {
        verify(mockSendMoney(100));
        verify(mockHomeCubit.updateBalance(400));
      },
    );

    blocTest<SendMoneyCubit, SendMoneyState>(
      'emits [SendMoneyLoading, SendMoneyError] when amount > balance',
      build: () => cubit,
      act: (cubit) => cubit.submitAmount(600),
      expect: () => [
        isA<SendMoneyLoading>(),
        isA<SendMoneyError>()
            .having((s) => s.message, 'message', 'Insufficient balance'),
      ],
      verify: (_) {
        verifyZeroInteractions(mockSendMoney);
      },
    );

    blocTest<SendMoneyCubit, SendMoneyState>(
      'emits [SendMoneyLoading, SendMoneyError] when use case returns ServerFailure',
      build: () {
        when(mockSendMoney(100)).thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.submitAmount(100),
      expect: () => [
        isA<SendMoneyLoading>(),
        isA<SendMoneyError>().having(
            (s) => s.message, 'message', 'Server error. Please try again.'),
      ],
    );
  });

  group('reset', () {
    blocTest<SendMoneyCubit, SendMoneyState>(
      'emits SendMoneyInitial',
      build: () => cubit,
      seed: () => SendMoneySuccess(
          Transaction(id: 1, amount: 100, timestamp: DateTime.now())),
      act: (cubit) => cubit.reset(),
      expect: () => [SendMoneyInitial()],
    );
  });
}
