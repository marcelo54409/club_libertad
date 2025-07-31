import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/request/inicio_request.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';

abstract class InicioRepository {
  Future<GenericResultAPI<List<InicioResponse>>> findInicio(
      InicioRequest? filters);
}
