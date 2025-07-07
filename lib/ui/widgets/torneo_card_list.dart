import 'package:flutter/material.dart';
import 'torneo_card.dart';

class UniqueColorGenerator {
  static final List<Color> _baseColors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
    Colors.pink,
    Colors.blueGrey,
    Colors.brown,
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  static Color getColorForKey(String key) {
    final hash = key.hashCode;
    final index = hash.abs() % _baseColors.length;
    return _baseColors[index];
  }
}

class TorneoCardList extends StatelessWidget {
  const TorneoCardList({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> torneos = [
      {'titulo': 'Copa Verano', 'subtitulo': 'Regional', 'puntos': 150},
      {'titulo': 'Liga Norte', 'subtitulo': 'Principal', 'puntos': 300},
      {'titulo': 'Open Trujillo', 'subtitulo': 'Abierto', 'puntos': 200},
      {'titulo': 'Torneo Junior', 'subtitulo': 'Juvenil', 'puntos': 100},
    ];

    torneos.sort((a, b) => (b['puntos'] as int).compareTo(a['puntos'] as int));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: Colors.lime, size: 26),
              SizedBox(width: 8),
              Text(
                'Puntos por torneo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: torneos.length,
            itemBuilder: (context, index) {
              final torneo = torneos[index];
              final String titulo = torneo['titulo'] as String;
              final Color colorFuerte =
                  UniqueColorGenerator.getColorForKey(titulo);
              final Color colorSuave = colorFuerte.withOpacity(0.15);

              return TorneoCard(
                titulo: titulo,
                subtitulo: torneo['subtitulo'] as String,
                puntos: torneo['puntos'] as int,
                colorFuerte: colorFuerte,
                colorSuave: colorSuave,
              );
            },
          ),
        ],
      ),
    );
  }
}
