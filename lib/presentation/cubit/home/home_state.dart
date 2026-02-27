part of 'home_cubit.dart';

class HomeState extends Equatable {
  final double balance;
  final bool isBalanceHidden;

  const HomeState({required this.balance, required this.isBalanceHidden});

  HomeState copyWith({double? balance, bool? isBalanceHidden}) {
    return HomeState(
      balance: balance ?? this.balance,
      isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
    );
  }

  @override
  List<Object?> get props => [balance, isBalanceHidden];
}
