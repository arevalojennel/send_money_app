part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final int timestamp;

  // Making the instance for throwing an error unique every instance
  AuthError(this.message) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [message, timestamp];
}
