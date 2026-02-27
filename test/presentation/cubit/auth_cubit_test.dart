import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:send_money_app/presentation/cubit/home/home_cubit.dart';
import 'package:send_money_app/data/datasources/transaction_remote_datasource.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateMocks([HomeCubit])
void main() {
  late MockHomeCubit mockHomeCubit;

  setUp(() {
    mockHomeCubit = MockHomeCubit();
    TransactionRemoteDataSourceImpl.clearLocalTransactions();
  });

  blocTest<AuthCubit, AuthState>(
    'emits [Authenticated] when login with correct credentials',
    build: () => AuthCubit(homeCubit: mockHomeCubit),
    act: (cubit) => cubit.login('user', 'pass'),
    expect: () => [isA<Authenticated>()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthError] when login with incorrect credentials',
    build: () => AuthCubit(homeCubit: mockHomeCubit),
    act: (cubit) => cubit.login('wrong', 'wrong'),
    expect: () => [isA<AuthError>()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthInitial] after logout',
    build: () => AuthCubit(homeCubit: mockHomeCubit),
    seed: () => Authenticated(),
    act: (cubit) => cubit.logout(),
    verify: (_) {
      verify(mockHomeCubit.updateBalance(500.00)).called(1);
    },
    expect: () => [AuthInitial()],
  );
}
