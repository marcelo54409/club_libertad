import 'package:club_libertad_front/data/repositories/endpoints_url.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/ranking/request/ranking_request.dart';
import 'package:club_libertad_front/domain/entities/ranking/response/ranking_response.dart';
import 'package:club_libertad_front/domain/repositories/ranking_repository.dart';
import 'package:http2/http2.dart';
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class RankingRepositoryImpl implements RankingRepository {
  final Http2 _http = Http2(url: rankingEndpoint);

  @override
  Future<GenericResultAPI<List<RankingResponse>>> findRanking(
      RankingRequest? filters) async {
    var result = GenericResultAPI<List<RankingResponse>>(
      statusCode: 200,
      message: "Listando Información",
      data: [],
    );

    String url = "/current";
    String params = "";

    if (filters != null) {
      final queryParams = filters.toJson().entries
          .map((entry) => "${entry.key}=${entry.value}")
          .join('&');
      if (queryParams.isNotEmpty) {
        params = "?$queryParams";
      }
    }

    try {
      final httpResult = await _http.get(url: "$url$params");
      result.statusCode = httpResult.statusCode;
      result.message = httpResult.message;

      if (httpResult.statusCode == 200) {
        final json = httpResult.data as Map<String, dynamic>;
        final rankingsJson = json['rankings'] as List<dynamic>;
        result.data = rankingsJson
            .map((item) => RankingResponse.fromJson(item))
            .toList();
      }
    } catch (e, stacktrace) {
      result.statusCode = 500;
      result.message = e.toString();
      Logger().e('Error en findRanking', error: e, stackTrace: stacktrace);
      Toasted.error(message: e.toString()).show();
      result.data = [];
    }

    return result;
  }
}
