part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginPost extends LoginEvent {
  final String email;
  final String password;

  const LoginPost({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'Login Post (email: $email, password: $password)';
}
