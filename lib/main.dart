// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'injection_container.dart' as di;
import 'presentation/cubit/auth/auth_cubit.dart';
import 'presentation/cubit/home/home_cubit.dart';
import 'presentation/cubit/send_money/send_money_cubit.dart';
import 'presentation/cubit/transactions/transactions_cubit.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/send_money_screen.dart';
import 'presentation/screens/transaction_history_screen.dart';
import 'data/datasources/transaction_remote_datasource.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  TransactionRemoteDataSourceImpl.clearLocalTransactions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<SendMoneyCubit>()),
        BlocProvider(create: (_) => di.sl<TransactionsCubit>()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Send Money App',
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/': (ctx) => const LoginScreen(),
          '/home': (ctx) => const HomeScreen(),
          '/send': (ctx) => SendMoneyScreen(),
          '/transactions': (ctx) => const TransactionHistoryScreen(),
        },
      ),
    );
  }
}
