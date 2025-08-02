import 'dart:convert';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/torneos/request/torneo_request.dart';
import 'package:club_libertad_front/domain/entities/torneos/response/torneo_response.dart';
import 'package:club_libertad_front/domain/repositories/torneo_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class TorneoRepositoryImpl implements TorneoRepository {
  static const String _baseUrl = 'https://apiclublibertad.wost.pe/api';

  @override
  Future<GenericResultAPI<List<TournamentResponse>>> findTorneo(
      TournamentRequest? filters) async {
    var result = GenericResultAPI<List<TournamentResponse>>(
      statusCode: 200,
      message: "Listando Información",
      data: [],
    );

    String url = "$_baseUrl/tournaments";
    String params = "";

    if (filters != null) {
      final Map<String, dynamic> queryParams = filters.toJson();

      params = queryParams.entries
          .where((entry) =>
              entry.value != null && entry.value.toString().isNotEmpty)
          .map((entry) =>
              '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
          .join('&');
    }

    if (params.isNotEmpty) {
      url = "$url?$params";
    }

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      result.statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        result.message = responseData['message'] ?? "Información obtenida";

        if (responseData['success'] == true && responseData['data'] != null) {
          final tournamentsJson = responseData['data'] as List<dynamic>;
          result.data = tournamentsJson
              .map((json) => TournamentResponse.fromJson(json))
              .toList();
        } else {
          result.data = [];
        }
      } else {
        result.message = "Error al consultar la API";
        result.data = [];
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
