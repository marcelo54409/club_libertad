
import 'package:club_libertad_front/features/auth/domain/datasources/auth_datasource.dart';
import 'package:club_libertad_front/features/auth/domain/entities/user.dart';
import 'package:club_libertad_front/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:club_libertad_front/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String nombre, String password) {
    return dataSource.login(nombre, password);
  }

}
