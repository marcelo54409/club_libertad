import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RendimientoCardWidget extends StatelessWidget {
  const RendimientoCardWidget({
    super.key,
    required this.victorias,
    required this.derrotas,
  });

  final int victorias;
  final int derrotas;

  @override
  Widget build(BuildContext context) {
    final int total = victorias + derrotas;
    final double porcentaje = total == 0 ? 0 : victorias / total;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      color: const Color(0xFFF4F4F5),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título con ícono
            Row(
              children: const [
                FaIcon(FontAwesomeIcons.arrowTrendUp,
                    color: Colors.black87, size: 18),
                SizedBox(width: 8),
                Text(
                  'Estadísticas de Rendimiento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Texto encima de la barra
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Partidos Ganados',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  '$victorias / $total',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Barra negra de rendimiento
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: porcentaje,
                minHeight: 10,
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),

            const SizedBox(height: 16),

            // Cuadros de victorias y derrotas
            Row(
              children: [
                Expanded(
                  child: _buildBox(
                    label: 'Victorias',
                    value: '$victorias',
                    color: Colors.green.shade100,
                    textColor: Colors.green.shade800,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBox(
                    label: 'Derrotas',
                    value: '$derrotas',
                    color: Colors.red.shade100,
                    textColor: Colors.red.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox({
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
