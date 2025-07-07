import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    super.key,
    required this.titulo,
    required this.numero,
    required this.icono,
    this.colorFondo = Colors.white,
    this.colorNumero = Colors.white,
    this.gradient,
    this.colorTexto = Colors.white, // ✅ nuevo parámetro
    this.onTap,
  });

  final String titulo;
  final String numero;
  final IconData icono;
  final Color colorFondo;
  final Color colorNumero;
  final Gradient? gradient;
  final Color colorTexto; // ✅ nuevo parámetro
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? colorFondo : null,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Texto (titulo y número)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorTexto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      numero,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorNumero,
                      ),
                    ),
                  ],
                ),
              ),
              FaIcon(
                icono,
                color: colorTexto,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
