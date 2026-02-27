import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(balance: 500.00, isBalanceHidden: false));

  void toggleBalanceVisibility() {
    emit(state.copyWith(isBalanceHidden: !state.isBalanceHidden));
  }

  void updateBalance(double newBalance) {
    emit(state.copyWith(balance: newBalance));
  }
}
