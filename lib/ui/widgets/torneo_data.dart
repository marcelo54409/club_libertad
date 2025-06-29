import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TorneoData {
  final String titulo;
  final String categoria;
  final String nombre;
  final String ciudad; // ✅ agregado
  final String fecha;
  final String monto;
  final int inscritos;
  final int totalCupos;
  final int puntos;
  final double porcentaje;
  final String superficie;
  final String estado; // puede ser "Abierto", "En curso", "Finalizado"

  TorneoData({
    required this.titulo,
    required this.categoria,
    required this.nombre,
    required this.ciudad,
    required this.fecha,
    required this.monto,
    required this.inscritos,
    required this.totalCupos,
    required this.puntos,
    required this.porcentaje,
    required this.superficie,
    required this.estado, // 👈 nuevo campo
  });
}

class TorneoCard extends StatelessWidget {
  final TorneoData data;

  const TorneoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Color _getEstadoColor(String estado) {
      switch (estado.toLowerCase()) {
        case 'abierto':
          return Colors.green;
        case 'en curso':
          return Colors.blue;
        case 'finalizado':
          return Colors.grey;
        default:
          return Colors.black26;
      }
    }

    return Stack(
      children: [
        // 🔴 Barra roja detrás
        Positioned(
          left: 13,
          top: 12,
          bottom: 11,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: _getEstadoColor(data.estado), // 👈 dinámico
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),

        // 🟦 Card encima con margen a la izquierda
        Container(
          margin:
              const EdgeInsets.fromLTRB(16, 8, 16, 8), // margen izquierdo extra
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y categoría
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.titulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 49, 133),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.categoria,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Nombre y ciudad
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text('${data.nombre} - ${data.ciudad}'),
                ],
              ),
              const SizedBox(height: 6),

              // Fecha y monto
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(data.fecha),
                  const SizedBox(width: 16),
                  const Icon(FontAwesomeIcons.dollarSign,
                      size: 14, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(data.monto),
                ],
              ),
              const SizedBox(height: 6),

              // Inscritos y puntos
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.deepPurple),
                  const SizedBox(width: 6),
                  Text('${data.inscritos}/${data.totalCupos} inscritos'),
                  const SizedBox(width: 16),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text('${data.puntos} pts'),
                ],
              ),
              const SizedBox(height: 12),

              // Barra de progreso
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: data.porcentaje / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text('${data.porcentaje.toStringAsFixed(0)}% inscritos'),
                ],
              ),
              const SizedBox(height: 12),

              // Superficie y botones
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Superficie: ${data.superficie}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Flexible(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      child: const Text('Ver detalle',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 35, 19),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      child: const Text('Inscribirse',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
