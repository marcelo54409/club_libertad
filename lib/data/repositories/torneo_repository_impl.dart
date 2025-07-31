import 'package:club_libertad_front/data/repositories/endpoints_url.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/torneos/request/torneo_request.dart';
import 'package:club_libertad_front/domain/entities/torneos/response/torneo_response.dart';
import 'package:club_libertad_front/domain/repositories/torneo_repository.dart';
import 'package:http2/http2.dart';
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class TorneoRepositoryImpl implements TorneoRepository {
  final Http2 _http = Http2(url: torneoEndpoint);

  @override
  Future<GenericResultAPI<List<TournamentResponse>>> findTorneo(
      TournamentRequest? filters) async {
    var result = GenericResultAPI<List<TournamentResponse>>(
      statusCode: 200,
      message: "Listando Información",
      data: [],
    );

    String url = "";
    String params = "";

    if (filters != null) {
      final Map<String, dynamic> queryParams = filters.toJson();

      params = queryParams.entries
          .where((entry) => entry.value != null && entry.value.toString().isNotEmpty)
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
          .join('&');
    }

    url = params.isNotEmpty ? "?$params" : "";

    try {
      final httpResult = await _http.get(url: url);

      result.statusCode = httpResult.statusCode;
      result.message = httpResult.message;

      if (httpResult.statusCode == 200 && httpResult.data != null) {
        final Map<String, dynamic> responseData =
            httpResult.data as Map<String, dynamic>;

        if (responseData.containsKey('tournaments')) {
          final tournamentsJson = responseData['tournaments'] as List<dynamic>;
          result.data = tournamentsJson
              .map((json) => TournamentResponse.fromJson(json))
              .toList();
        } else {
          result.data = [];
        }
      }
    } catch (e, stacktrace) {
      result.statusCode = 500;
      result.message = e.toString();
      result.data = [];
      Logger().e('Error en findTorneo:', error: e, stackTrace: stacktrace);
      Toasted.error(message: "Ocurrió un error al consultar torneos").show();
    }

    return result;
  }
}
