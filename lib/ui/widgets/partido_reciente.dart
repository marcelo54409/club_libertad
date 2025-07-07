import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ... importaciones
import 'package:intl/intl.dart';

class PartidoRecienteCard extends StatelessWidget {
  const PartidoRecienteCard({
    super.key,
    required this.nombreCompleto,
    required this.liga,
    required this.fecha,
    required this.esVictoria,
    required this.marcador,
  });

  final String nombreCompleto;
  final String liga;
  final DateTime fecha;
  final bool esVictoria;
  final String marcador;

  @override
  Widget build(BuildContext context) {
    final Color resultadoColor = esVictoria ? Colors.green : Colors.red;
    final Color resultadoTextColor = Colors.white;
    final String resultadoTexto = esVictoria ? 'Victoria' : 'Derrota';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre + resultado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nombreCompleto,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: resultadoColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    resultadoTexto,
                    style: TextStyle(
                      fontSize: 12,
                      color: resultadoTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      liga,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Text(
                  marcador,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Liga

            const SizedBox(height: 4),

            // Fecha + marcador
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.calendarDays,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd MMM yyyy').format(fecha),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
