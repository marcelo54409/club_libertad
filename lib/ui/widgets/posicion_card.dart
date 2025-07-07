import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TuPosicionCard extends StatelessWidget {
  final int puestoActual;
  final int puestoAnterior;
  final int puntaje;

  const TuPosicionCard({
    super.key,
    required this.puestoActual,
    required this.puestoAnterior,
    required this.puntaje,
  });

  @override
  Widget build(BuildContext context) {
    final diferencia = puestoAnterior - puestoActual;
    final bool subio = diferencia > 0;
    final bool bajo = diferencia < 0;

    final icono = subio
        ? FontAwesomeIcons.arrowUp
        : bajo
            ? FontAwesomeIcons.arrowDown
            : FontAwesomeIcons.minus;

    final iconoColor = subio
        ? Colors.greenAccent
        : bajo
            ? Colors.orangeAccent
            : Colors.white;

    final textoCambio = diferencia == 0
        ? 'Sin cambios'
        : '${subio ? '+' : '-'}${diferencia.abs()}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFE0091B), // Rojo oscuro
            Color(0xFF243875), // Azul oscuro
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu posición actual',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '#$puestoActual',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$puntaje pts',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  FaIcon(
                    icono,
                    color: iconoColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    textoCambio,
                    style: TextStyle(
                      color: iconoColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'vs semana anterior',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
