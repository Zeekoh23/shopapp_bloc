part of 'signup_login_bloc.dart';

abstract class SignupLoginState extends Equatable {
  const SignupLoginState();

  @override
  List<Object> get props => [];
}

class SignupLoginInitial extends SignupLoginState {}

class SignupLoginLoading extends SignupLoginState {}

class SignupLoginFailure extends SignupLoginState {
  final String error;
  const SignupLoginFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure ($error)';
}
