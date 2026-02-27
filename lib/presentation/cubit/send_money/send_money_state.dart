part of 'send_money_cubit.dart';

abstract class SendMoneyState extends Equatable {
  const SendMoneyState();

  @override
  List<Object?> get props => [];
}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

class SendMoneySuccess extends SendMoneyState {
  final Transaction transaction;

  const SendMoneySuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class SendMoneyError extends SendMoneyState {
  final String message;

  const SendMoneyError(this.message);

  @override
  List<Object?> get props => [message];
}
