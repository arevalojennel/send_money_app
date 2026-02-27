// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'core/network/api_client.dart';
import 'data/datasources/transaction_remote_datasource.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/usecases/get_transactions.dart';
import 'domain/usecases/send_money.dart';
import 'presentation/cubit/auth/auth_cubit.dart';
import 'presentation/cubit/home/home_cubit.dart';
import 'presentation/cubit/send_money/send_money_cubit.dart';
import 'presentation/cubit/transactions/transactions_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(() => AuthCubit());
  sl.registerLazySingleton(() => HomeCubit());
  sl.registerFactory(
    () => SendMoneyCubit(
      sendMoneyUseCase: sl(),
      homeCubit: sl(),
    ),
  );
  // 👇 FIXED: TransactionsCubit is now a singleton
  sl.registerLazySingleton(
    () => TransactionsCubit(
      getTransactionsUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => SendMoney(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(apiClient: sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(client: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
