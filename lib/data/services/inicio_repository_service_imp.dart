import 'package:club_libertad_front/data/repositories/inicio_repository_impl.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/request/inicio_request.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/inicio_repository.dart';
import 'package:club_libertad_front/domain/services/inicio_service.dart';

class InicioRepositoryServiceImp implements InicioService {
  final InicioRepository _repository = InicioRepositoryImpl();

  @override
  Future<GenericResultAPI<List<InicioResponse>>> findInicio(
      InicioRequest? filters) async {
    return await _repository.findInicio(filters);
  }
}
