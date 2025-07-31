import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/torneos/request/torneo_request.dart';
import 'package:club_libertad_front/domain/entities/torneos/response/torneo_response.dart';

abstract class TorneoService {
  Future<GenericResultAPI<List<TournamentResponse>>> findTorneo(
      TournamentRequest? filters);
}
