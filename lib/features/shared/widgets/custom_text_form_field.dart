import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar para inputFormatters
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextFormField extends ConsumerWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters; // Agregar inputFormatters
  final FocusNode? focusNode;
  const CustomTextFormField({
    super.key,
    this.label,
    this.suffixIcon,
    this.hint,
    this.errorMessage,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.controller,
    this.initialValue,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black54),
      borderRadius: BorderRadius.circular(6),
    );

    const borderRadius = Radius.circular(6);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
          topRight: borderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16.8,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
        initialValue: initialValue,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters, // Aplicar inputFormatters
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          floatingLabelStyle: const TextStyle(fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorStyle: const TextStyle(fontSize: 12),
          errorBorder:
              border.copyWith(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
              border.copyWith(borderSide: BorderSide(color: Colors.red)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
        ),
      ),
    );
  }
}
