import 'package:flutter/material.dart';

class MatchInfoCard extends StatelessWidget {
  final String title;
  final String phase;
  final int playersRemaining;
  final int totalPlayers;
  final String nextMatchDate;
  final String circleText;

  const MatchInfoCard({
    super.key,
    required this.title,
    required this.phase,
    required this.playersRemaining,
    required this.totalPlayers,
    required this.nextMatchDate,
    required this.circleText,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = playersRemaining / totalPlayers;
    final percentage = (progress * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 182, 182, 223),
            Color.fromARGB(255, 255, 195, 199),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.black, // Borde negro
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(999), 
                ),
                child: Text(
                  circleText, 
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Fase
          Text(
            phase,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
          const SizedBox(height: 8),
          // Jugadores restantes y porcentaje
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jugadores restantes',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 136, 245),
                ),
              ),
              Text(
                '$percentage% Completado',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 136, 245),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Próximo partido
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
                color: Color.fromARGB(255, 3, 136, 245),
              ),
              const SizedBox(width: 8),
              Text(
                'Próximo partido - $nextMatchDate',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 136, 245),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
