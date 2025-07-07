import 'package:flutter/material.dart';

class PlayerRow extends StatelessWidget {
  final String name;
  final String country;
  final int position;
  final String avatarPath;
  final List<int> stats;
  final List<Color> statColors;

  const PlayerRow({
    super.key,
    required this.name,
    required this.country,
    required this.position,
    required this.avatarPath,
    required this.stats,
    required this.statColors,
  });

  // Función para calcular colores
  static List<Color> getStatColors(List<int> statsA, List<int> statsB) {
    return List<Color>.generate(3, (index) {
      if (statsA[index] > statsB[index]) {
        return Colors.green;
      } else if (statsA[index] < statsB[index]) {
        return Colors.grey;
      } else {
        return Colors.amber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(avatarPath),
          backgroundColor: Colors.white,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              country,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: position == 1
                ? Colors.red
                : Colors.blue, // rojo si es 1, azul si no
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '#$position',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: statColors[i],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stats[i].toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
