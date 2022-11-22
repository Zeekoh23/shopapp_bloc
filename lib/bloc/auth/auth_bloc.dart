import 'package:equatable/equatable.dart';

import '../bloc_exports.dart';
import '../../helpers/api/api_read.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRead authApi;
  AuthBloc({required this.authApi}) : super(AuthLoading()) {
    on<AppStarted>(_appStarted);
    on<LoggedIn>(_loggedIn);
    on<LoggedOut>(_loggedOut);
  }

  /* @override
  AuthState get initialState => AuthInitialised();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = authApi.isAuth;
      if (hasToken) {
        yield AuthAuthenticated();
      } else {
        yield AuthUnAuthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthLoading();
      authApi.token;
      yield AuthAuthenticated();
    }
    if (event is LoggedOut) {
      // yield AuthLoading();
      yield AuthUnAuthenticated();
    }
  }*/

  void _appStarted(AppStarted event, Emitter<AuthState> emit) async {
    final bool hasToken = await authApi.tryAutoLogin();
    //final bool hasToken = authApi.isAuth;
    if (hasToken) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnAuthenticated());
    }
  }

  void _loggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // await authApi.persistToken(event.token);
    emit(AuthAuthenticated());
  }

  void _loggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authApi.logout();
    emit(AuthUnAuthenticated());
  }
}
