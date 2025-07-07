import 'package:flutter/material.dart';

class IndicadorIconoTexto extends StatelessWidget {
  final Widget icono;
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
      width: 100, 
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: iconoColor,
              size: 25,
            ),
            child: icono,
          ),
          const SizedBox(height: 8),
          Text(
            "$cantidad %",
            style: const TextStyle(
              fontSize: 25,
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
