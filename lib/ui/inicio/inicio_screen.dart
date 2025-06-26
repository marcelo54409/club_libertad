import 'package:club_libertad_front/ui/widgets/march_info.dart';
import 'package:club_libertad_front/ui/widgets/march_summary.dart';
import 'package:club_libertad_front/ui/widgets/match_info_card.dart';
import 'package:club_libertad_front/ui/widgets/player_info.dart';
import 'package:club_libertad_front/ui/widgets/players_stats_card.dart';
import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lastMatch = MatchInfo(
      playerName: 'Juan Pérez',
      playerCountry: 'Perú',
      playerPosition: 1,
      playerAvatar: 'assets/images/jugador.png',
      opponentName: 'Carlos Gómez',
      opponentCountry: 'Argentina',
      opponentPosition: 2,
      opponentAvatar: 'assets/images/oponente.png',
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
      // ... más players
    ];

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Topbar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black12, // Línea inferior ligera
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Sombra ligera
                      blurRadius: 4,
                      offset: Offset(0, 2), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/escudo.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Para que alineen a la izquierda
                        children: const [
                          Text(
                            'Club Libertad',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Tenis Trujillo',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_active_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
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
                        PlayerRow(
                          name: lastMatch.playerName,
                          country: lastMatch.playerCountry,
                          position: lastMatch.playerPosition,
                          avatarPath: lastMatch.playerAvatar,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PlayerRow(
                          name: lastMatch.opponentName,
                          country: lastMatch.opponentCountry,
                          position: lastMatch.opponentPosition,
                          avatarPath: lastMatch.opponentAvatar,
                        ),
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
                        // Fila superior con ícono y texto
                        Row(
                          children: const [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.blue,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Torneos en curso',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        MatchInfoCard(
                          title: 'Torneo Apertura',
                          phase: 'Semifinales',
                          playersRemaining: 4,
                          totalPlayers: 16,
                          nextMatchDate: '24 Jun 2025',
                          circleText:
                              'Clasificado', // <- Aquí envías el texto que quieres
                        ),
                        const SizedBox(height: 15),
                        MatchInfoCard(
                          title: 'Torneo Apertura',
                          phase: 'Semifinales',
                          playersRemaining: 5,
                          totalPlayers: 16,
                          nextMatchDate: '24 Jun 2025',
                          circleText:
                              'Semifinal', // <- Aquí envías el texto que quieres
                        ),
                        const SizedBox(height: 5),
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
                              Icons.timer_sharp,
                              color: Colors.blue,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Próximos Partidos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        MatchSummaryCard(
                          imagePath: 'assets/images/escudo.png',
                          name: 'Juan Pérez',
                          position: 'Posición #1',
                          score: 3,
                          isInFavor: true,
                          date: 'Mañana',
                          time: '14:30',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MatchSummaryCard(
                          imagePath: 'assets/images/escudo.png',
                          name: 'ana Pérez',
                          position: 'Posición #1',
                          score: 3,
                          isInFavor: true,
                          date: 'Mañana',
                          time: '14:30',
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
              SizedBox(height: 15),
            ],
          ),
        ));
  }
}
