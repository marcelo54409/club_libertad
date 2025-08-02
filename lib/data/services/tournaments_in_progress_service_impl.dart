import 'package:club_libertad_front/data/repositories/tournaments_in_progress_repository_impl.dart';
import 'package:club_libertad_front/domain/entities/generic_result_api.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/repositories/tournaments_in_progress_repository.dart';
import 'package:club_libertad_front/domain/services/tournaments_in_progress_service.dart';

class TournamentsInProgressServiceImpl implements TournamentsInProgressService {
  final TournamentsInProgressRepository _repository =
      TournamentsInProgressRepositoryImpl();

  @override
  Future<GenericResultAPI<TournamentsInProgressResponse>>
      getTournamentsInProgress() async {
    return await _repository.getTournamentsInProgress();
  }
}
