import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // <- color de fondo "medio plomo"

      body: Column(
        children: [
          // Topbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12, // Línea inferior ligera
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Sombra ligera
                  blurRadius: 4,
                  offset: Offset(0, 2), // Desplazamiento de la sombra
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/escudo.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Para que alineen a la izquierda
                    children: const [
                      Text(
                        'Club Libertad',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Tenis Trujillo',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_active_rounded),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          // Resto de tu vista aquí
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Rankings',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Clasificación de jugadores',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.emoji_events_outlined,
                  color: Colors.lime,
                  size: 26,
                ),
                SizedBox(width: 8), // Espacio entre ícono y texto
                Text(
                  'Puntos por torneo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
