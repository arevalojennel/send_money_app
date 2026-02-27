// lib/presentation/screens/transaction_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:send_money_app/domain/entities/transaction.dart';
import 'package:send_money_app/presentation/theme/app_colors.dart';
import '../../constants/image_strings.dart';
import '../cubit/transactions/transactions_cubit.dart';
import '../cubit/auth/auth_cubit.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load transactions when screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionsCubit>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            if (state is TransactionsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TransactionsLoaded) {
              final transactions = state.transactions;
              if (transactions.isEmpty) {
                return const Center(child: Text('No transactions yet.'));
              }
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (ctx, index) {
                  final txn = transactions[index];
                  return buildTransactionRow(txn);
                  //  ListTile(
                  //   leading: SizedBox(
                  //     height: 30,
                  //     width: 30,
                  //     child: SvgPicture.asset(mSendFilledIcon),
                  //   ),
                  //   title: Text(
                  //     '₱ ${txn.amount.toStringAsFixed(2)}',
                  //     style: Theme.of(context).textTheme.titleLarge,
                  //   ),
                  //   subtitle: Text(
                  //     'Sent on ${txn.timestamp.toLocal()}'.split('.')[0],
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  // );
                },
              );
            } else if (state is TransactionsError) {
              return Center(child: Text(state.message));
            }
            // TransactionsInitial or other states
            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }

  Widget buildTransactionRow(Transaction txn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.onBackground.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2.5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(mSendFilledIcon),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₱ ${txn.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Sent on ${txn.timestamp.toLocal()}'.split('.')[0],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
