import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';

abstract class FeaturedPlayersRepository {
  Future<GenericResultAPI<FeaturedPlayersResponse>> getFeaturedPlayers(
      {int limit = 8});
}
