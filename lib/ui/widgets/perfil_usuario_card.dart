import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilUsuarioCard extends StatelessWidget {
  const PerfilUsuarioCard({
    super.key,
    required this.imageUrl,
    required this.nombre,
    required this.apellido,
    required this.ciudad,
    required this.pais,
    required this.ranking,
    required this.puntos,
    required this.torneos,
    required this.titulos,
    required this.victorias,
    required this.winrate,
    this.onEdit,
    this.avatarSize = 56,
  });

  final String imageUrl;
  final String nombre;
  final String apellido;
  final String ciudad;
  final String pais;
  final int ranking;
  final int puntos;
  final int torneos;
  final int titulos;
  final int victorias;
  final double winrate;
  final VoidCallback? onEdit;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(avatarSize / 2),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: avatarSize,
                            height: avatarSize,
                            color: Colors.grey.shade300,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                        )
                      : Image.asset(
                          imageUrl,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre + editar
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$nombre $apellido',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Ciudad, País + Editar a la derecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '$ciudad, $pais',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.edit, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 18,
                            onPressed: onEdit,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Ranking #$ranking',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$puntos pts',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(torneos.toString(), 'Torneos'),
                _buildStat(titulos.toString(), 'Títulos'),
                _buildStat(victorias.toString(), 'Victorias'),
                _buildStat('${winrate.toStringAsFixed(1)}%', 'Winrate'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String numero, String label) {
    return Column(
      children: [
        Text(
          numero,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
