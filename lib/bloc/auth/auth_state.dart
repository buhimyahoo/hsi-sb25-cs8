import 'package:submission8/model/user_model.dart';

enum AuthStates { initial, loading, success, failure }

class AuthState {
  final UserModel? user;
  final AuthStates status;
  final Exception? error;

  AuthState({this.user, this.status = AuthStates.initial, this.error});

  factory AuthState.initial() => AuthState();

  AuthState copyWith({UserModel? user, AuthStates? status, Exception? error}) {
    return AuthState(
      error: error,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
