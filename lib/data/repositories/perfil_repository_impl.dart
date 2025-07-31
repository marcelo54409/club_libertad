import 'package:club_libertad_front/data/repositories/endpoints_url.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/perfil/request/player_request.dart';
import 'package:club_libertad_front/domain/entities/perfil/response/player_response.dart';
import 'package:club_libertad_front/domain/repositories/perfil_repository.dart';
import 'package:http2/http2.dart';
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class PerfilRepositoryImpl implements PerfilRepository {
  final Http2 _http = Http2(url: perfilEndpoint);

  @override
  Future<GenericResultAPI<List<PlayerResponse>>> findPlayer(
      PlayerRequest? filters) async {
    var result = GenericResultAPI<List<PlayerResponse>>(
        statusCode: 200, message: "Listando Información", data: []);

    String url = "";
    String params = "";

    if (filters != null) {
      final queryParams = filters.toJson().entries
          .map((entry) => "${entry.key}=${entry.value}")
          .join('&');
      if (queryParams.isNotEmpty) {
        params = "?$queryParams";
      }
    }

    url = "$perfilEndpoint$params";

    try {
      final httpResult = await _http.get(url: url);

      result.statusCode = httpResult.statusCode;
      result.message = httpResult.message;

      if (httpResult.statusCode == 200) {
        final jsonData = httpResult.data as Map<String, dynamic>;
        final playersJson = jsonData['players'] as List<dynamic>;
        result.data =
            playersJson.map((json) => PlayerResponse.fromJson(json)).toList();
      }
    } catch (e, stacktrace) {
      result.statusCode = 500;
      result.message = e.toString();
      Logger().e('error:', error: e, stackTrace: stacktrace);
      Toasted.error(message: e.toString()).show();
      result.data = [];
    }

    return result;
  }
}
