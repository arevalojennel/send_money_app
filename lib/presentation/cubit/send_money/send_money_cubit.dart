import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/send_money.dart';
import '../../../domain/entities/transaction.dart';
import '../../../core/error/failures.dart';
import '../home/home_cubit.dart';

part 'send_money_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  final SendMoney sendMoneyUseCase;
  final HomeCubit homeCubit;

  SendMoneyCubit({required this.sendMoneyUseCase, required this.homeCubit})
      : super(SendMoneyInitial());

  Future<void> submitAmount(double amount) async {
    emit(SendMoneyLoading());

    if (amount > homeCubit.state.balance) {
      emit(const SendMoneyError('Insufficient balance'));
      return;
    }

    final result = await sendMoneyUseCase(amount);
    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(const SendMoneyError('Server error. Please try again.'));
        } else if (failure is InvalidAmountFailure) {
          emit(const SendMoneyError('Invalid amount'));
        } else {
          emit(const SendMoneyError('Unknown error'));
        }
      },
      (transaction) {
        homeCubit.updateBalance(homeCubit.state.balance - amount);
        emit(SendMoneySuccess(transaction));
      },
    );
  }

  void reset() => emit(SendMoneyInitial());
}
