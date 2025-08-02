import 'package:club_libertad_front/data/repositories/featured_players_repository_impl.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/featured_players_repository.dart';
import 'package:club_libertad_front/domain/services/featured_players_service.dart';

class FeaturedPlayersServiceImpl implements FeaturedPlayersService {
  final FeaturedPlayersRepository _repository = FeaturedPlayersRepositoryImpl();

  @override
  Future<GenericResultAPI<FeaturedPlayersResponse>> getFeaturedPlayers(
      {int limit = 8}) async {
    return await _repository.getFeaturedPlayers(limit: limit);
  }
}
