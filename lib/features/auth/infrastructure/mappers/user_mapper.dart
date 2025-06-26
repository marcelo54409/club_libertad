import 'package:club_libertad_front/features/auth/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    // Parse the JSON into a LoginResponse object
    final user = User.fromJson(json["data"]);

    return user;
  }

  static Map<String, dynamic> userEntityToJson(User user) {
    return user.toJson();
  }
}
