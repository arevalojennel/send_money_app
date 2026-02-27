import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_transactions.dart';
import '../../../domain/entities/transaction.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactions getTransactionsUseCase;

  TransactionsCubit({required this.getTransactionsUseCase})
      : super(TransactionsInitial());

  Future<void> loadTransactions() async {
    print('📥 loadTransactions() called'); //loging purposes
    emit(TransactionsLoading());
    final result = await getTransactionsUseCase();
    result.fold(
      (failure) {
        print('❌ Load failed'); //loging purposes
        emit(const TransactionsError('Failed to load transactions'));
      },
      (transactions) {
        print('✅ Loaded ${transactions.length} transactions'); //loging purposes
        emit(TransactionsLoaded(transactions));
      },
    );
  }
}
