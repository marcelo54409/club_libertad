import 'package:club_libertad_front/ui/ranking/ranking_screen.dart';
import 'package:club_libertad_front/ui/widgets/march_info.dart';
import 'package:club_libertad_front/ui/widgets/march_summary.dart';
import 'package:club_libertad_front/ui/widgets/match_info_card.dart';
import 'package:club_libertad_front/ui/widgets/player_info.dart';
import 'package:club_libertad_front/ui/widgets/players_stats_card.dart';
import 'package:club_libertad_front/ui/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lastMatch = MatchInfo(
      playerName: 'Juan Pérez',
      playerCountry: 'Perú',
      playerPosition: 1,
      playerAvatar: 'assets/images/escudo.png',
      opponentName: 'Carlos Gómez',
      opponentCountry: 'Argentina',
      opponentPosition: 2,
      opponentAvatar: 'assets/images/escudo.png',
    );
    final players = [
      PlayerStats(
        imagePath: 'assets/images/escudo.png',
        name: 'Juan Pérez',
        position: 'Delantero',
        city: 'Lima',
        streak: '3 victorias seguidas',
        wins: 10,
        gamesPlayed: 12,
      ),
    ];
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
    final List<MatchInfoCard> matchInfoList = [
      MatchInfoCard(
        title: 'Torneo Verano',
        phase: 'Octavos de final',
        playersRemaining: 8,
        totalPlayers: 16,
        nextMatchDate: '30/06/2025',
        circleText: 'Semifinal',
      ),
      MatchInfoCard(
        title: 'Torneo Primavera',
        phase: 'Semifinal',
        playersRemaining: 4,
        totalPlayers: 16,
        nextMatchDate: '03/07/2025',
        circleText: 'Final',
      ),
    ];
    final statsA = [5, 12, 28];
    final statsB = [3, 15, 22];

    final statColorsA = PlayerRow.getStatColors(statsA, statsB);
    final statColorsB = PlayerRow.getStatColors(statsB, statsA);

    final List<PlayerRow> playersRow = [
      PlayerRow(
        name: 'Juan Pérez',
        country: 'Perú',
        position: 1,
        avatarPath: 'assets/images/escudo.png',
        stats: statsA,
        statColors: statColorsA,
      ),
      PlayerRow(
        name: 'María Gómez',
        country: 'Argentina',
        position: 2,
        avatarPath: 'assets/images/escudo.png',
        stats: statsB,
        statColors: statColorsB,
      ),
    ];

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Topbar
              TopBarClub(), // 👈 Reutilizable

              // Resto de tu vista aquí
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '¡Hola, Usuario!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
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
              SizedBox(height: 15),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Borde lateral que sobresale
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
                  // Tu contenedor principal
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fila superior con ícono y texto
                        Row(
                          children: const [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.lime,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Último torneo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Título de copa
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Copa "nombre"',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Subtítulo centrado
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fase',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...playersRow
                            .map((player) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: PlayerRow(
                                    name: player.name,
                                    country: player.country,
                                    position: player.position,
                                    avatarPath: player.avatarPath,
                                    stats: player.stats,
                                    statColors: player.statColors,
                                  ),
                                ))
                            .toList(),

                        const SizedBox(height: 12),
                        // Etiqueta de ganador
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
                            child: const Text(
                              'Ganador: Jugador',
                              style: TextStyle(
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
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      '5',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Aces',
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      '12',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Winners',
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      '28',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
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
                          children: const [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons
                                      .calendar_month_outlined, // icono para Aces
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Ayer Hora',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.pin_drop_outlined, // icono para Winners
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Nombre Cancha',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons
                                      .timer_sharp, // icono para Rally más largo
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Tiempo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Información de Torneo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...matchInfoList.map(
                          (info) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MatchInfoCard(
                              title: info.title,
                              phase: info.phase,
                              playersRemaining: info.playersRemaining,
                              totalPlayers: info.totalPlayers,
                              nextMatchDate: info.nextMatchDate,
                              circleText: info.circleText,
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                        PlayerStatsList(players: players),
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
                          // Acción para TORNEOS
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.grey), // borde plomo
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // bordes circulares
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>  RankingScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.grey), // borde plomo
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
