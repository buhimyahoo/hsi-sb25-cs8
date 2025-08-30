import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission8/bloc/auth/auth_event.dart';
import 'package:submission8/bloc/auth/auth_state.dart';
import 'package:submission8/services/user/user_services.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.service) : super(AuthState.initial()) {
    on<RegisterAuthEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AuthStates.loading));

        final user = await service.register(
          name: event.name,
          email: event.email,
          password: event.password,
        );

        emit(state.copyWith(status: AuthStates.success, user: user));
      } on Exception catch (e) {
        emit(state.copyWith(status: AuthStates.failure, error: e));
      }
    });

    on<CheckAuthEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AuthStates.loading));

        final user = await service.user();

        emit(state.copyWith(status: AuthStates.success, user: user));
      } on Exception catch (e) {
        emit(state.copyWith(status: AuthStates.failure, error: e));
      }
    });

    on<LoginAuthEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AuthStates.loading));

        final user = await service.login(
          email: event.email,
          password: event.password,
        );

        emit(state.copyWith(status: AuthStates.success, user: user));
      } on Exception catch (e) {
        emit(state.copyWith(status: AuthStates.failure, error: e));
      }
    });

    on<LogoutAuthEvent>((event, emit) async {
      await service.logout();

      emit(AuthState.initial());
    });
  }

  final UserService service;
}
