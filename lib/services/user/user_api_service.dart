import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission8/exceptions/server_exception.dart';
import 'package:submission8/model/user_model.dart';
import 'package:submission8/services/user/user_services.dart';

class UserApiServiceImpl implements UserService {
  Future<Dio> get _dio async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: 'https://hsinote.donisaputra.com/api',
        headers: {
          if (token != null) 'AUTHORIZATION': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

    dio.interceptors.add(LogInterceptor(responseBody: true));

    return dio;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', response.data['data']['token']);

        return UserModel.fromJson(response.data['data']['user']);
      } else {
        throw ServerException(response.data['meta']['message']);
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['meta']['message']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', response.data['data']['token']);

        return UserModel.fromJson(response.data['data']['user']);
      } else {
        throw ServerException(response.data['meta']['message']);
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['meta']['message']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> user() async {
    try {
      final dio = await _dio;

      final response = await dio.get('/user');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['meta']['message']);
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['meta']['message']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final dio = await _dio;

      await dio.post('/logout');

      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('token');

      return true;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['meta']['message']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
