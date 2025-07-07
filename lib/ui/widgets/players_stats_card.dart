import 'package:club_libertad_front/ui/widgets/resumen_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayerStats {
  final String imagePath;
  final String name;
  final String position;
  final String city;
  final String streak;
  final int wins;
  final int gamesPlayed;
  final int ranking;
  PlayerStats({
    required this.imagePath,
    required this.name,
    required this.position,
    required this.city,
    required this.streak,
    required this.wins,
    required this.ranking,
    required this.gamesPlayed,
  });

  double get percentage => gamesPlayed == 0 ? 0 : (wins / gamesPlayed) * 100;
}

class PlayerStatsList extends StatelessWidget {
  final List<PlayerStats> players;
  const PlayerStatsList({super.key, required this.players});

  Color _getPercentageColor(double percentage) {
    if (percentage >= 70) return Colors.green;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  Widget _buildPlayerImage(String imagePath) {
    final isRemote =
        imagePath.startsWith('http') || imagePath.startsWith('https');
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isRemote
          ? Image.network(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            )
          : Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: players.map((player) {
        final percentage = player.percentage;
        final color = _getPercentageColor(percentage);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  final percentage = player.percentage.toStringAsFixed(1);
                  final BuildContext parentContext = context;

                  return Dialog(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Perfil del jugador',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                player.imagePath,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '#${player.ranking}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  player.city,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildCustomStatBox(
                                  label: 'Partidos',
                                  value: player.gamesPlayed.toString(),
                                  backgroundColor: const Color(0xFFD0E8FF),
                                  textColor: const Color(0xFF1D4ED8),
                                ),
                                const SizedBox(width: 8),
                                _buildCustomStatBox(
                                  label: 'Victorias',
                                  value: player.wins.toString(),
                                  backgroundColor: const Color(0xFFD1FAE5),
                                  textColor: const Color(0xFF047857),
                                ),
                                const SizedBox(width: 8),
                                _buildCustomStatBox(
                                  label: 'Win Rate',
                                  value: '${percentage.toString()}%',
                                  backgroundColor: const Color(0xFFEDE9FE),
                                  textColor: const Color(0xFF6D28D9),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Estado: ${player.streak}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Torneo actual: Copa Primavera',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();

                                      // 2. Luego navega con go_router usando el contexto exterior
                                      Future.microtask(() {
                                        parentContext.go('/perfil');
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Ver perfil completo',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
              ;
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildPlayerImage(player.imagePath),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                player.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${percentage.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                                Text(
                                  '${player.wins}/${player.gamesPlayed}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              player.position,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              player.city,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          player.streak,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomStatBox({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
