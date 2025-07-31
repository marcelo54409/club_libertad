import 'package:club_libertad_front/data/repositories/torneo_repository_impl.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/torneos/request/torneo_request.dart';
import 'package:club_libertad_front/domain/entities/torneos/response/torneo_response.dart';
import 'package:club_libertad_front/domain/repositories/torneo_repository.dart';
import 'package:club_libertad_front/domain/services/torneo_service.dart';

class TorneoRepositoryServiceImp implements TorneoService {
  final TorneoRepository _repository = TorneoRepositoryImpl();

  @override
  Future<GenericResultAPI<List<TournamentResponse>>> findTorneo(
      TournamentRequest? filters) async {
    return await _repository.findTorneo(filters);
  }
}
