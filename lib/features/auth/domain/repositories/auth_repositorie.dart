
import 'package:club_libertad_front/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String nombre, String password);

  Future<User> checkAuthStatus(String token);

Future<User> register(String nombre, String apellido, String correo, String password);

}
