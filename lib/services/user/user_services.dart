import 'package:submission8/model/user_model.dart';

abstract class UserService {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel?> user();

  Future<bool> logout();
}
