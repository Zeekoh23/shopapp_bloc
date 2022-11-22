part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitialised extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthAuthorised extends AuthState {}

class AuthLoading extends AuthState {}
