import 'package:equatable/equatable.dart';

import '../../../helpers/api/api_read.dart';
import '../../bloc_exports.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.authApi,
    required this.authBloc,
  }) : super(LoginInitial()) {
    on<LoginPost>(_loginPost);
  } //;
  final ApiRead authApi;
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

  void _loginPost(LoginPost event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final response = await authApi.login(event.email, event.password);
    print('email is ' + authApi.email);

    try {
      String token = response.data['token'];
      authBloc.add(
        LoggedIn(token: token),
      );
      emit(LoginInitial());
    } catch (err) {
      emit(LoginFailure(error: response.message));
    }
  }
}
