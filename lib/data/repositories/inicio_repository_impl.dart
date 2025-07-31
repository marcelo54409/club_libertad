import 'package:club_libertad_front/data/repositories/endpoints_url.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/request/inicio_request.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/inicio_repository.dart';
import 'package:http2/http2.dart';
import 'package:logger/logger.dart';
import 'package:utils/toasted/toasted.dart';

class InicioRepositoryImpl implements InicioRepository {
  final Http2 _http = Http2(url: inicioEndpoint);

  @override
  Future<GenericResultAPI<List<InicioResponse>>> findInicio(
      InicioRequest? filters) async {
    var result = GenericResultAPI<List<InicioResponse>>(
        statusCode: 200, message: "Listando Información", data: []);

    String url = "/latest-match";
    String params = "";

    if (filters != null) {
      if (filters.tournamentId != null) {
        url = "$url/${filters.tournamentId}";
      }

      params = filters.convertClassToParams();
      if (params.isNotEmpty) {
        url = '$url?$params';
      }
    }

    try {
      var httpResult = await _http.get(url: url);
      result.statusCode = httpResult.statusCode;
      result.message = httpResult.message;
      if (httpResult.statusCode == 200) {
        final dataJson = httpResult.data as List<dynamic>;
        result.data =
            dataJson.map((json) => InicioResponse.fromJson(json)).toList();
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
