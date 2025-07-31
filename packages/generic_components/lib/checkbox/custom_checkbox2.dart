import 'package:flutter/material.dart';

class CustomCheckbox2 extends StatelessWidget {
  // Propiedades del checkbox
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color checkColor;
  final String? label;
  final TextStyle? labelStyle;
  final bool enabled; // Nuevo atributo para habilitar/deshabilitar

  const CustomCheckbox2({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.label,
    this.labelStyle,
    this.enabled = true, // Valor por defecto: habilitado
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: enabled
              ? onChanged
              : null, // Solo permite cambiar si está habilitado
          activeColor: activeColor,
          checkColor: checkColor,
        ),
        if (label != null)
          GestureDetector(
            onTap: () {
              if (enabled) {
                onChanged(!value);
              }
            },
            child: Text(
              label!,
              style: labelStyle ??
                  TextStyle(
                      fontSize: 16.0,
                      color: enabled
                          ? Colors.black
                          : Colors
                              .grey), // Si no está habilitado el color del texto cambia a gris
            ),
          ),
      ],
    );
  }
}
