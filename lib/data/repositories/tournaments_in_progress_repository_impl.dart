import 'dart:convert';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/tournaments_in_progress_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class TournamentsInProgressRepositoryImpl
    implements TournamentsInProgressRepository {
  static const String _baseUrl = 'https://apiclublibertad.wost.pe/api';

  @override
  Future<GenericResultAPI<TournamentsInProgressResponse>>
      getTournamentsInProgress() async {
    var result = GenericResultAPI<TournamentsInProgressResponse>(
        statusCode: 200, message: "Listando Torneos en Curso", data: null);

    String url = "$_baseUrl/home/tournaments-in-progress";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
        },
      );

      result.statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          result.data = TournamentsInProgressResponse.fromJson(jsonData);
          result.message =
              jsonData['message'] ?? 'Torneos en curso cargados exitosamente';
        } else {
          result.data = null;
          result.message =
              jsonData['message'] ?? 'No hay torneos en curso disponibles';
        }
      } else {
        result.message =
            'Error al cargar torneos en curso: ${response.statusCode}';
        result.data = null;
      }
    } catch (e, stacktrace) {
      result.statusCode = 500;
      result.message = e.toString();
      Logger().e('error:', error: e, stackTrace: stacktrace);
      Toasted.error(message: e.toString()).show();
      result.data = null;
    }
    return result;
  }
}
