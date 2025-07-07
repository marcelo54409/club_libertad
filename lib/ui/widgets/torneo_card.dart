import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TorneoCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final int puntos;
  final Color colorFuerte;
  final Color colorSuave;

  const TorneoCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.puntos,
    required this.colorFuerte,
    required this.colorSuave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorSuave,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorFuerte,
          width: 0.9,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorFuerte,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.trophy,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${puntos.toString()} pts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorFuerte,
            ),
          ),
        ],
      ),
    );
  }
}
