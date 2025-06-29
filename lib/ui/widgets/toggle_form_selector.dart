import 'package:flutter/material.dart';

class ToggleFormSelector extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ToggleFormSelector({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.grey[400]!; // Fondo plomo general
    final Color selectedFillColor = Colors.white; // Fondo blanco al seleccionar
    final Color selectedTextColor =
        Colors.black87; // Texto negro en seleccionado
    final Color unselectedTextColor =
        Colors.black54; // Texto gris en no seleccionado
    final Color borderColor = Colors.grey[400]!; // Borde igual que el fondo

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ToggleButtons(
        isSelected: List.generate(
          options.length,
          (index) => index == selectedIndex,
        ),
        onPressed: onChanged,
        borderRadius: BorderRadius.circular(10),
        borderColor: borderColor,
        selectedBorderColor: Colors.grey[300],
        fillColor: selectedFillColor,
        selectedColor: selectedTextColor,
        color: unselectedTextColor,
        constraints: BoxConstraints(
          minHeight: 44,
          minWidth: (MediaQuery.of(context).size.width - 40) / options.length,
          // Resta 32 por el padding horizontal usual, ajusta si no tienes padding
        ),
        children: options
            .map(
              (label) => Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            )
            .toList(),
      ),
    );
  }
}
