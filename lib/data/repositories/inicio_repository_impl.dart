import 'dart:convert';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/request/inicio_request.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/inicio_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class InicioRepositoryImpl implements InicioRepository {
  static const String _baseUrl = 'https://apiclublibertad.wost.pe/api';

  @override
  Future<GenericResultAPI<List<InicioResponse>>> findInicio(
      InicioRequest? filters) async {
    var result = GenericResultAPI<List<InicioResponse>>(
        statusCode: 200, message: "Listando Información", data: []);

    String url = "$_baseUrl/home/latest-match";

    if (filters != null && filters.tournamentId != null) {
      url = "$url/${filters.tournamentId}";
    }

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
          // La API devuelve un solo objeto, no una lista
          final inicioResponse = InicioResponse.fromJson(jsonData);
          result.data = [inicioResponse];
          result.message = jsonData['message'] ?? 'Datos cargados exitosamente';
        } else {
          result.data = [];
          result.message = jsonData['message'] ?? 'No hay datos disponibles';
        }
      } else {
        result.message = 'Error al cargar datos: ${response.statusCode}';
        result.data = [];
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
