import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:send_money_app/presentation/cubit/home/home_cubit.dart';

void main() {
  group('HomeCubit', () {
    blocTest<HomeCubit, HomeState>(
      'initial state has balance 500 and balance not hidden',
      build: () => HomeCubit(),
      verify: (cubit) {
        expect(cubit.state.balance, 500.0);
        expect(cubit.state.isBalanceHidden, false);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'toggleBalanceVisibility flips isBalanceHidden',
      build: () => HomeCubit(),
      act: (cubit) => cubit.toggleBalanceVisibility(),
      expect: () => [
        isA<HomeState>().having((s) => s.isBalanceHidden, 'hidden', true),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'updateBalance changes balance',
      build: () => HomeCubit(),
      act: (cubit) => cubit.updateBalance(300),
      expect: () => [
        isA<HomeState>().having((s) => s.balance, 'balance', 300.0),
      ],
    );
  });
}
