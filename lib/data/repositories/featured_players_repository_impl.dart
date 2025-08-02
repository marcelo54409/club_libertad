import 'dart:convert';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/featured_players_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class FeaturedPlayersRepositoryImpl implements FeaturedPlayersRepository {
  static const String _baseUrl = 'https://apiclublibertad.wost.pe/api';

  @override
  Future<GenericResultAPI<FeaturedPlayersResponse>> getFeaturedPlayers(
      {int limit = 8}) async {
    var result = GenericResultAPI<FeaturedPlayersResponse>(
        statusCode: 200, message: "Listando Jugadores Destacados", data: null);

    String url = "$_baseUrl/home/featured-players?limit=$limit";

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
          result.data = FeaturedPlayersResponse.fromJson(jsonData);
          result.message = jsonData['message'] ??
              'Jugadores destacados cargados exitosamente';
        } else {
          result.data = null;
          result.message =
              jsonData['message'] ?? 'No hay jugadores destacados disponibles';
        }
      } else {
        result.message =
            'Error al cargar jugadores destacados: ${response.statusCode}';
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
