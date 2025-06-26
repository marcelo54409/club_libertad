import 'package:flutter/material.dart';

class MatchSummaryCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String position;
  final int score;
  final bool isInFavor; // true: "a favor", false: "en contra"
  final String date;
  final String time;

  const MatchSummaryCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.position,
    required this.score,
    required this.isInFavor,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      position,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      score.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isInFavor ? 'a favor' : 'en contra',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Título
                          const Text(
                            'Preparación del partido',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // VS nombre
                          const Text(
                            'VS Juan Pérez',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Copa
                          const Text(
                            'Copa Primavera',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: const [
                                      Text(
                                        'Fecha',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '24/06/2025',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: const [
                                      Text(
                                        'Hora',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.green),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '18:00',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // <- Pegado a la izquierda
                                    children: const [
                                      Text(
                                        'Cancha',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // <- Pegado a la izquierda
                                    children: const [
                                      Text(
                                        'Ronda',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // <- Pegado a la izquierda
                                    children: const [
                                      Text(
                                        'Ranking Rival',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // <- Pegado a la izquierda
                                    children: const [
                                      Text(
                                        'Historial',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Recordar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Estadísticas',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.play_arrow_outlined,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
