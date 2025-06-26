
import 'package:club_libertad_front/features/auth/domain/entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String nombre, String password);

  Future<User> checkAuthStatus(String token);

}
