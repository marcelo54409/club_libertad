import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/perfil/request/player_request.dart';
import 'package:club_libertad_front/domain/entities/perfil/response/player_response.dart';

abstract class PerfilRepository {
  Future<GenericResultAPI<List<PlayerResponse>>> findPlayer(
      PlayerRequest? filters);
}
