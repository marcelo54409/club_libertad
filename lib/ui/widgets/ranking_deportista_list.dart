import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Deportista {
  final int posicion;
  final String nombre;
  final String ciudad;
  final String imagen;
  final int puntos;
  final int torneosAFavor;
  final int victorias;
  final String genero;
  Deportista(
      {required this.posicion,
      required this.nombre,
      required this.ciudad,
      required this.imagen,
      required this.puntos,
      required this.torneosAFavor,
      required this.victorias,
      required this.genero});
}

class RankingDeportistasList extends StatelessWidget {
  final List<Deportista> deportistas;

  const RankingDeportistasList({
    super.key,
    required this.deportistas,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: deportistas.map((d) => _DeportistaItem(d)).toList(),
    );
  }
}

class _DeportistaItem extends StatelessWidget {
  final Deportista deportista;
  const _DeportistaItem(this.deportista);

  IconData _getIconForPosition(int pos) {
    if (pos == 1) return FontAwesomeIcons.crown;
    if (pos == 2 || pos == 3) return FontAwesomeIcons.medal;
    return FontAwesomeIcons.user;
  }

  Color _getIconColorForPosition(int pos) {
    if (pos == 1) return Colors.amber;
    if (pos == 2) return Colors.grey;
    if (pos == 3) return Colors.brown;
    return Colors.black38;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '#${deportista.posicion}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              FaIcon(
                _getIconForPosition(deportista.posicion),
                color: _getIconColorForPosition(deportista.posicion),
                size: 20,
              ),
            ],
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(deportista.imagen),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deportista.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      deportista.ciudad,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '${deportista.puntos}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.trending_up, size: 18, color: Colors.green),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${deportista.torneosAFavor} torneos · ${deportista.victorias} victorias',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
