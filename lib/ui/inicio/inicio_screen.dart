import 'dart:developer';

import 'package:club_libertad_front/data/services/inicio_repository_service_imp.dart';
import 'package:club_libertad_front/data/services/featured_players_service_impl.dart';
import 'package:club_libertad_front/data/services/tournaments_in_progress_service_impl.dart';
import 'package:club_libertad_front/domain/entities/inicio/request/inicio_request.dart';
import 'package:club_libertad_front/domain/entities/inicio/response/inicio_response.dart';
import 'package:club_libertad_front/domain/services/inicio_service.dart';
import 'package:club_libertad_front/domain/services/featured_players_service.dart';
import 'package:club_libertad_front/domain/services/tournaments_in_progress_service.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/ui/widgets/march_summary.dart';
import 'package:club_libertad_front/ui/widgets/player_info.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class InicioScreen extends ConsumerStatefulWidget {
  const InicioScreen({super.key});

  @override
  ConsumerState<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends ConsumerState<InicioScreen> {
  final InicioService _inicioService = InicioRepositoryServiceImp();
  final FeaturedPlayersService _featuredPlayersService =
      FeaturedPlayersServiceImpl();
  final TournamentsInProgressService _tournamentsInProgressService =
      TournamentsInProgressServiceImpl();
  List<InicioResponse> _listInicio = [];
  MatchData? _latestMatch;
  List<FeaturedPlayer> _featuredPlayers = [];
  List<TournamentInProgress> _tournamentsInProgress = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  void onLoading(bool? loading) {
    if (loading == null || loading == false) {
      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.show();
    }
  }

  Future<void> loadData() async {
    onLoading(true);

    // Cargar datos en paralelo
    await Future.wait([
      loadLastestMatch(),
      loadFeaturedPlayers(),
      loadTournamentsInProgress(),
    ]);

    onLoading(false);
  }

  Future<void> loadLastestMatch() async {
    final responseConfiguracion =
        await _inicioService.findInicio(InicioRequest(tournamentId: 1));

    if (responseConfiguracion.statusCode == 200) {
      if (responseConfiguracion.data != null &&
          responseConfiguracion.data!.isNotEmpty) {
        setState(() {
          _listInicio = responseConfiguracion.data!;
          _latestMatch = _listInicio.first.data;
        });
      } else {
        log("La estructura de datos no es una lista o está vacía.");
        setState(() {
          _listInicio = [];
          _latestMatch = null;
        });
      }
    } else {
      log("Error al cargar último partido: ${responseConfiguracion.message ?? ''}");
      setState(() {
        _listInicio = [];
        _latestMatch = null;
      });
    }
  }

  Future<void> loadFeaturedPlayers() async {
    final response = await _featuredPlayersService.getFeaturedPlayers(limit: 8);

    if (response.statusCode == 200 && response.data != null) {
      setState(() {
        _featuredPlayers = response.data!.data;
      });
    } else {
      log("Error al cargar jugadores destacados: ${response.message}");
      setState(() {
        _featuredPlayers = [];
      });
    }
  }

  Future<void> loadTournamentsInProgress() async {
    final response =
        await _tournamentsInProgressService.getTournamentsInProgress();

    if (response.statusCode == 200 && response.data != null) {
      setState(() {
        _tournamentsInProgress = response.data!.data;
      });
    } else {
      log("Error al cargar torneos en curso: ${response.message}");
      setState(() {
        _tournamentsInProgress = [];
      });
    }
  }

  Widget build(BuildContext context) {
    final user = ref.watch(authProvider); // tipo User?
    final username = user.user?.username ?? 'Usuario';

    final List<MatchSummary> matchSummaryList = [
      MatchSummary(
        imagePath: 'assets/images/escudo.png',
        name: 'Carlos Gómez',
        position: 'Delantero',
        score: 3,
        isInFavor: true,
        date: '28/06/2025',
        time: '17:00',
      ),
      MatchSummary(
        imagePath: 'assets/images/escudo.png',
        name: 'Luis Torres',
        position: 'Defensa',
        score: 1,
        isInFavor: false,
        date: '29/06/2025',
        time: '16:00',
      ),
    ];

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const SafeArea(
              child: TopBarClub(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header con saludo
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, $username!',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Clasificación de jugadores',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 16,
                    top: 4,
                    bottom: 3,
                    child: Container(
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.lime,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Último partido',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_latestMatch != null) ...[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              _latestMatch!.tournament?.name ??
                                  'Torneo Desconocido',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              _latestMatch!.round,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Jugador 1
                          PlayerRow(
                            name:
                                '${_latestMatch!.player1.firstName} ${_latestMatch!.player1.lastName}',
                            country: _latestMatch!.player1.countryCode,
                            position: _latestMatch!.winnerId ==
                                    _latestMatch!.player1.id
                                ? 1
                                : 2,
                            avatarPath: 'assets/images/escudo.png',
                            stats: [
                              _latestMatch!.aces1,
                              _latestMatch!.winners1,
                              _latestMatch!.longestRallySeconds
                            ],
                            statColors: [
                              Colors.green,
                              Colors.blue,
                              Colors.orange
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Jugador 2
                          PlayerRow(
                            name:
                                '${_latestMatch!.player2.firstName} ${_latestMatch!.player2.lastName}',
                            country: _latestMatch!.player2.countryCode,
                            position: _latestMatch!.winnerId ==
                                    _latestMatch!.player2.id
                                ? 1
                                : 2,
                            avatarPath: 'assets/images/escudo.png',
                            stats: [
                              _latestMatch!.aces2,
                              _latestMatch!.winners2,
                              _latestMatch!.longestRallySeconds
                            ],
                            statColors: [
                              Colors.green,
                              Colors.blue,
                              Colors.orange
                            ],
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Ganador: ${_latestMatch!.winner.firstName} ${_latestMatch!.winner.lastName}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_latestMatch!.aces1 + _latestMatch!.aces2}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Aces Totales',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_latestMatch!.winners1 + _latestMatch!.winners2}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Winners Totales',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_latestMatch!.longestRallySeconds}s',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Rally más largo',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_latestMatch!.dateTime.day}/${_latestMatch!.dateTime.month}/${_latestMatch!.dateTime.year}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.pin_drop_outlined,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _latestMatch!.court,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.timer_sharp,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_latestMatch!.durationMinutes}min',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_latestMatch!.tournament != null) ...[
                            const SizedBox(height: 8),
                            const Divider(
                              color: Colors.black12,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.sports_tennis,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _latestMatch!.tournament!.surface,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _latestMatch!.tournament!.location,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.emoji_events_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _latestMatch!.tournament!.type,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ] else ...[
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No hay datos del último partido',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Torneos en Curso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_tournamentsInProgress.isNotEmpty) ...[
                          ..._tournamentsInProgress.map(
                            (tournament) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header del torneo
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tournament.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${tournament.type} - Nivel ${tournament.level}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            tournament.status,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Información del torneo
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      tournament.location,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.sports_tennis,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    tournament.surface,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${tournament.currentRegistrations}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[700],
                                                ),
                                              ),
                                              Text(
                                                'de ${tournament.totalSlots}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.blue[600],
                                                ),
                                              ),
                                              const Text(
                                                'jugadores',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Información adicional
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Inscripción',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '${tournament.registrationFee} ${tournament.currency}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Puntos',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '${tournament.points} pts',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          const Center(
                            child: Text(
                              'No hay torneos en curso disponibles',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Resumen de Partidos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...matchSummaryList.map(
                          (match) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MatchSummary(
                              imagePath: match.imagePath,
                              name: match.name,
                              position: match.position,
                              score: match.score,
                              isInFavor: match.isInFavor,
                              date: match.date,
                              time: match.time,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.supervised_user_circle_outlined,
                              color: Colors.purple,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Jugadores Destacados',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        if (_featuredPlayers.isNotEmpty) ...[
                          ..._featuredPlayers.map(
                            (featuredPlayer) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  children: [
                                    // Avatar del jugador
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(25),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/escudo.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Información del jugador
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${featuredPlayer.player.firstName} ${featuredPlayer.player.lastName}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${featuredPlayer.player.city}, ${featuredPlayer.player.countryCode}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.purple[100],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              featuredPlayer.highlightText,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.purple[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Indicador de país
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        featuredPlayer.player.countryCode,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          const Center(
                            child: Text(
                              'No hay jugadores destacados disponibles',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/torneos');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.emoji_events_outlined,
                                color: Colors.black),
                            SizedBox(height: 8),
                            Text(
                              'TORNEOS',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/ranking');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.trending_up_outlined,
                                color: Colors.black),
                            SizedBox(height: 8),
                            Text(
                              'RANKINGS',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
            ],
          ),
        ));
  }
}
