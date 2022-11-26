part of 'signup_login_bloc.dart';

abstract class SignupLoginEvent extends Equatable {
  const SignupLoginEvent();
}

class LoginPost extends SignupLoginEvent {
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

class SignupPost extends SignupLoginEvent {
  final String email;
  final String password;
  final String passwordConfirm;

  const SignupPost({
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  @override
  List<Object> get props => [email, password, passwordConfirm];

  @override
  String toString() =>
      'Signup Post (email: $email, password: $password, passwordConfirm: $passwordConfirm)';
}
