import 'dart:convert';

import 'package:club_libertad_front/config/constants/environment.dart';
import 'package:club_libertad_front/features/auth/domain/datasources/auth_datasource.dart';
import 'package:club_libertad_front/features/auth/domain/entities/user.dart';
import 'package:club_libertad_front/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:club_libertad_front/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:club_libertad_front/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:dio/dio.dart';


class AuthDatasourceImpl implements AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      throw CustomError(
          'Check Status Datasource no implementado - require chequear status');
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String nombre, String password) async {
    try {
      final response = await dio
          .post('login', data: {'username': nombre, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      print("aca estoy4");
      final userKey = jsonEncode(response.data);
      await KeyValueStorageServiceImpl().setKeyValue('user', userKey);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Incorrecto usuario o contraseña');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError("Revisar conexión a internet");
      }

      rethrow; // Re-lanzar la excepción original en otros casos de DioException
    } catch (e) {
      throw Exception();
    }
  }
@override
Future<User> register(String nombre, String apellido, String correo, String password) async {
  try {
    final response = await dio.post('register', data: {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'password': password,
    });

    final user = UserMapper.userJsonToEntity(response.data);
    final userKey = jsonEncode(response.data);
    await KeyValueStorageServiceImpl().setKeyValue('user', userKey);
    return user;
  } on DioException catch (e) {
    if (e.response?.statusCode == 400) {
      // Suponiendo que el backend devuelve errores tipo 400 para validaciones
      throw CustomError(e.response?.data['message'] ?? 'Datos inválidos');
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      throw CustomError("Revisar conexión a internet");
    }

    rethrow;
  } catch (e) {
    throw CustomError("Error inesperado al registrar");
  }
}

}
