import 'package:flutter/material.dart';

class ToggleFormSelector extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color selectedColor;
  final Color selectedTextColor;

  const ToggleFormSelector({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.selectedColor = Colors.white,
    this.selectedTextColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.grey[300]!;
    final Color unselectedTextColor = Colors.black54;
    final Color borderColor = Colors.grey[400]!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 10) / options.length;

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ToggleButtons(
            isSelected:
                List.generate(options.length, (i) => i == selectedIndex),
            onPressed: onChanged,
            borderRadius: BorderRadius.circular(6),
            borderColor: borderColor,
            selectedBorderColor: borderColor,
            fillColor: selectedColor,
            selectedColor: selectedTextColor,
            color: unselectedTextColor,
            constraints: BoxConstraints(
              minHeight: 40,
              minWidth: itemWidth,
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
      },
    );
  }
}
