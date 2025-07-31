import 'package:club_libertad_front/data/repositories/ranking_repository_impl.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/ranking/request/ranking_request.dart';
import 'package:club_libertad_front/domain/entities/ranking/response/ranking_response.dart';
import 'package:club_libertad_front/domain/repositories/ranking_repository.dart';
import 'package:club_libertad_front/domain/services/ranking_service.dart';

class RankingRepositoryServiceImp implements RankingService {
  final RankingRepository _repository = RankingRepositoryImpl();

  @override
  Future<GenericResultAPI<List<RankingResponse>>> findRanking(
      RankingRequest? filters) async {
    return await _repository.findRanking(filters);
  }
}
