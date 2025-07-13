import 'package:flutter/material.dart';

class MatchData {
  final String teamA;
  final String teamB;
  final String? winner;

  MatchData({required this.teamA, required this.teamB, this.winner});
}

class TournamentBracket extends StatelessWidget {
  final List<List<MatchData>> rounds;

  const TournamentBracket({super.key, required this.rounds});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 2.5,
        panEnabled: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // o center si prefieres
              children: _buildRoundsWithConnections(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRoundsWithConnections() {
    List<Widget> widgets = [];

    for (int i = 0; i < rounds.length; i++) {
      // Agregar la ronda actual
      widgets.add(_buildRound(rounds[i], i));

      // Agregar conexiones si no es la última ronda
      if (i < rounds.length - 1) {
        widgets.add(_buildConnections(rounds[i], rounds[i + 1]));
      }
    }

    return widgets;
  }

  Widget _buildRound(List<MatchData> matches, int roundIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ronda ${roundIndex + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          ...matches.map((match) => _buildMatchWithBracket(match)).toList(),
        ],
      ),
    );
  }

  Widget _buildMatchWithBracket(MatchData match) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Equipos a la izquierda
          Column(
            children: [
              _buildTeamBox(match.teamA, match.winner == match.teamA),
              const SizedBox(height: 8),
              _buildTeamBox(match.teamB, match.winner == match.teamB),
            ],
          ),
          // Líneas de conexión (llaves)
          _buildBracketLines(match),
          // Ganador a la derecha (si existe)
          if (match.winner != null) _buildWinnerBox(match.winner!),
        ],
      ),
    );
  }

  Widget _buildBracketLines(MatchData match) {
    return Container(
      width: 60,
      height: 100,
      child: CustomPaint(
        painter: BracketPainter(
          hasWinner: match.winner != null,
          winnerIsTeamA: match.winner == match.teamA,
        ),
      ),
    );
  }

  Widget _buildConnections(
      List<MatchData> currentRound, List<MatchData> nextRound) {
    return Container(
      width: 40,
      child: CustomPaint(
        painter: ConnectionPainter(
          currentRoundSize: currentRound.length,
          nextRoundSize: nextRound.length,
        ),
      ),
    );
  }

  Widget _buildTeamBox(String team, bool isWinner) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isWinner ? Colors.green : Colors.grey.shade400,
          width: isWinner ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          team,
          style: TextStyle(
            fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            color: isWinner ? Colors.green : Colors.black87,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildWinnerBox(String winner) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(
          color: Colors.green,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            winner,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Painter para las líneas de llaves individuales
class BracketPainter extends CustomPainter {
  final bool hasWinner;
  final bool winnerIsTeamA;

  BracketPainter({required this.hasWinner, required this.winnerIsTeamA});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final winnerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Líneas horizontales desde cada equipo
    final teamAY = size.height * 0.25;
    final teamBY = size.height * 0.75;
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;

    // Línea desde equipo A
    canvas.drawLine(
      Offset(0, teamAY),
      Offset(centerX, teamAY),
      hasWinner && winnerIsTeamA ? winnerPaint : paint,
    );

    // Línea desde equipo B
    canvas.drawLine(
      Offset(0, teamBY),
      Offset(centerX, teamBY),
      hasWinner && !winnerIsTeamA ? winnerPaint : paint,
    );

    // Línea vertical conectora
    canvas.drawLine(
      Offset(centerX, teamAY),
      Offset(centerX, teamBY),
      paint,
    );

    // Línea hacia el ganador (si existe)
    if (hasWinner) {
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(size.width, centerY),
        winnerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Painter para las conexiones entre rondas
class ConnectionPainter extends CustomPainter {
  final int currentRoundSize;
  final int nextRoundSize;

  ConnectionPainter({
    required this.currentRoundSize,
    required this.nextRoundSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Calcular posiciones basadas en el número de matches
    final currentSpacing = size.height / (currentRoundSize + 1);
    final nextSpacing = size.height / (nextRoundSize + 1);

    // Dibujar líneas de conexión
    for (int i = 0; i < nextRoundSize; i++) {
      final nextY = nextSpacing * (i + 1);
      final currentY1 = currentSpacing * (i * 2 + 1);
      final currentY2 = currentSpacing * (i * 2 + 2);

      // Líneas desde los matches actuales
      canvas.drawLine(
        Offset(0, currentY1),
        Offset(size.width * 0.5, currentY1),
        paint,
      );

      canvas.drawLine(
        Offset(0, currentY2),
        Offset(size.width * 0.5, currentY2),
        paint,
      );

      // Línea vertical conectora
      canvas.drawLine(
        Offset(size.width * 0.5, currentY1),
        Offset(size.width * 0.5, currentY2),
        paint,
      );

      // Línea hacia el siguiente match
      canvas.drawLine(
        Offset(size.width * 0.5, (currentY1 + currentY2) / 2),
        Offset(size.width, nextY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
