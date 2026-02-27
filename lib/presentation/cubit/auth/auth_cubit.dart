import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/transaction_remote_datasource.dart';
import '../../cubit/home/home_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final HomeCubit? homeCubit;

  AuthCubit({this.homeCubit}) : super(AuthInitial());

  void login(String username, String password) {
    if (username == 'user' && password == 'pass') {
      emit(Authenticated());
    } else {
      emit(AuthError('Invalid credentials'));
    }
  }

  void logout() {
    homeCubit?.updateBalance(500.00);
    TransactionRemoteDataSourceImpl.clearLocalTransactions();
    emit(AuthInitial());
  }
}
