import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/ranking/request/ranking_request.dart';
import 'package:club_libertad_front/domain/entities/ranking/response/ranking_response.dart';

abstract class RankingService {
  Future<GenericResultAPI<List<RankingResponse>>> findRanking(
      RankingRequest? filters);
}
