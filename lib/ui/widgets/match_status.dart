import 'package:flutter/material.dart';

enum MatchStatus { programado, enVivo, finalizado }

class MatchCard extends StatelessWidget {
  final String fase;
  final MatchStatus status;
  final String jugadorA;
  final String jugadorB;
  final String marcador;
  final String ganador;

  const MatchCard({
    super.key,
    required this.fase,
    required this.status,
    required this.jugadorA,
    required this.jugadorB,
    required this.marcador,
    required this.ganador,
  });

  Color get _statusColor {
    switch (status) {
      case MatchStatus.enVivo:
        return Colors.red;
      case MatchStatus.finalizado:
        return Colors.green;
      case MatchStatus.programado:
      default:
        return Colors.blue;
    }
  }

  String get _statusText {
    switch (status) {
      case MatchStatus.enVivo:
        return 'En vivo';
      case MatchStatus.finalizado:
        return 'Finalizado';
      case MatchStatus.programado:
      default:
        return 'Programado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color lightBg = _statusColor.withOpacity(0.12);

    Widget _playerTile(String nombre) {
      final bool isWinner = nombre == ganador;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isWinner ? lightBg : Colors.white,
          border: Border.all(
            color: isWinner ? _statusColor : Colors.grey.shade300,
            width: isWinner ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          nombre,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    Color _getColorForStatus(MatchStatus status) {
      switch (status) {
        case MatchStatus.finalizado:
          return Colors.green;
        case MatchStatus.enVivo:
          return Colors.red;
        case MatchStatus.programado:
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _statusColor,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(31, 91, 90, 90),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* ---------- Cabecera fase + estado ---------- */
          Row(
            children: [
              Text(
                fase,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusText,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /* ------------ Jugador A -------------- */
          _playerTile(jugadorA),

          /* ------------- “vs” ------------------ */
          const SizedBox(height: 6),
          const Text(
            'vs',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),

          /* ------------ Jugador B -------------- */
          _playerTile(jugadorB),

          /* ------------- Marcador -------------- */
          const SizedBox(height: 10),
          Text(
            marcador,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
