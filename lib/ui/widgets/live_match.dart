import 'package:flutter/material.dart';

class LiveMatchCard extends StatefulWidget {
  final String copa;
  final String marcador;
  final String jugadorA;
  final String jugadorB;
  final String cancha;
  final VoidCallback onVerPartido;

  const LiveMatchCard({
    super.key,
    required this.copa,
    required this.marcador,
    required this.jugadorA,
    required this.jugadorB,
    required this.cancha,
    required this.onVerPartido,
  });

  @override
  State<LiveMatchCard> createState() => _LiveMatchCardState();
}

class _LiveMatchCardState extends State<LiveMatchCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Fila: Copa + chip en vivo
          Row(
            children: [
              Text(
                widget.copa,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _blinkController,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'EN VIVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Marcador
          Text(
            widget.marcador,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          /// VS
          Text(
            '${widget.jugadorA} vs ${widget.jugadorB}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          /// Cancha
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 18, color: Colors.black38),
              const SizedBox(width: 4),
              Text(
                widget.cancha,
                style: const TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Botón "Ver partido en vivo"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => mostrarDialogoPartidoEnVivo(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'Ver partido en vivo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void mostrarDialogoPartidoEnVivo(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: _LiveMatchDialogContent(),
    ),
  );
}

class _LiveMatchDialogContent extends StatefulWidget {
  @override
  State<_LiveMatchDialogContent> createState() =>
      _LiveMatchDialogContentState();
}

class _LiveMatchDialogContentState extends State<_LiveMatchDialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Título
          const Text(
            'Partido en vivo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: FadeTransition(
              opacity: _blinkController,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'EN VIVO',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Nombre de la copa
          const Center(
            child: Text(
              'Copa Primavera',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Marcador
          const Center(
            child: Text(
              '6-3, 4-6, 2-1',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// VS
          const Center(
            child: Text(
              'Juan Pérez vs Carlos Gómez',
              style: TextStyle(fontSize: 15),
            ),
          ),

          const SizedBox(height: 12),

          /// Cancha
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.location_on_outlined, size: 18, color: Colors.black38),
              SizedBox(width: 4),
              Text(
                'Central Court',
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Botón
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text('Ver transmisión completa'),
            ),
          ),
        ],
      ),
    );
  }
}
