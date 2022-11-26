import 'package:equatable/equatable.dart';

import '../../bloc_exports.dart';

part 'signup_login_state.dart';
part 'signup_login_event.dart';

class SignupLoginBloc extends Bloc<SignupLoginEvent, SignupLoginState> {
  SignupLoginBloc({
    required this.authApi,
    required this.authBloc,
  }) : super(SignupLoginInitial()) {
    on<LoginPost>(_loginPost);
    on<SignupPost>(_signupPost);
  } //;
  final AuthApi authApi;
  final AuthBloc authBloc;

  /* @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPost) {
      yield LoginLoading();
      final response = await authApi.login(event.email, event.password);

      try {
        String token = response.data;
        authBloc.add(
          LoggedIn(token: token),
        );
        yield LoginInitial();
      } catch (err) {
        yield LoginFailure(error: response.message);
      }
    }
  }*/

  void _loginPost(LoginPost event, Emitter<SignupLoginState> emit) async {
    emit(SignupLoginLoading());
    final response = await authApi.login(event.email, event.password);
    print('email is ' + authApi.email);

    try {
      String token = response.data['token'];
      authBloc.add(
        LoggedIn(token: token),
      );
      emit(SignupLoginInitial());
    } catch (err) {
      emit(SignupLoginFailure(error: response.message));
    }
  }

  void _signupPost(SignupPost event, Emitter<SignupLoginState> emit) async {
    emit(SignupLoginLoading());

    final response = await authApi.signup(
      event.email,
      event.password,
      event.passwordConfirm,
    );
    print('email is ' + authApi.email);
    try {
      String token = response.data['token'];
      authBloc.add(
        LoggedIn(token: token),
      );
    } catch (err) {
      emit(SignupLoginFailure(error: response.message));
    }
  }
}
