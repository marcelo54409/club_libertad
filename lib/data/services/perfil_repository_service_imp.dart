import 'package:club_libertad_front/data/repositories/perfil_repository_impl.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/perfil/request/player_request.dart';
import 'package:club_libertad_front/domain/entities/perfil/response/player_response.dart';
import 'package:club_libertad_front/domain/repositories/perfil_repository.dart';
import 'package:club_libertad_front/domain/services/perfil_service.dart';
class PerfilRepositoryServiceImp implements PerfilService {
  final PerfilRepository _repository = PerfilRepositoryImpl();

  @override
  Future<GenericResultAPI<List<PlayerResponse>>> findPlayer(
      PlayerRequest? filters) async {
    return await _repository.findPlayer(filters);
  }
}
