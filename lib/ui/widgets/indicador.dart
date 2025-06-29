import 'package:flutter/material.dart';

class IndicadorIconoTexto extends StatelessWidget {
  final Widget icono; // Cambiado a Widget para aceptar Icon o FaIcon
  final Color iconoColor;
  final String cantidad;
  final String etiqueta;

  const IndicadorIconoTexto({
    super.key,
    required this.icono,
    required this.iconoColor,
    required this.cantidad,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // puedes ajustar este valor según necesidad
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: iconoColor,
              size: 30,
            ),
            child: icono,
          ),
          const SizedBox(height: 8),
          Text(
            cantidad,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
