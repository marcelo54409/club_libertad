import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

import '../../forms/form_dynamic/widgets/InputDecorationForm.dart';

enum TypeTextField { string, int, decimal }

class TextFormField2 extends StatefulWidget {
  final String? label;
  final String? hint;
  final Map<String, GenericItemForm>? formSave;
  final String? formKey;
  final dynamic defaultValue;
  final dynamic Function()? customDefaultValue;
  final bool? required;
  final bool? search;
  final bool? autofocus;
  final bool? showClear;
  final bool? enabled;
  final bool? readOnly;
  final TextStyle? titleTextStyle;
  final TypeTextField? type;
  final void Function(dynamic value)? onChange;
  final void Function(String value)? onBlur;
  final InputDecoration? decoration;
  final Color? colorBackground; // Nuevo parámetro
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? cantidadDecimales;

  const TextFormField2(
      {super.key,
      this.defaultValue,
      this.decoration,
      this.cantidadDecimales,
      this.customDefaultValue,
      this.enabled,
      this.readOnly,
      this.label,
      this.formSave,
      this.titleTextStyle,
      this.formKey,
      this.hint,
      this.required,
      this.search,
      this.type,
      this.showClear,
      this.onBlur,
      this.onChange,
      this.colorBackground, // Añadido al constructor
      this.validator,
      this.focusNode,
      this.autofocus});

  @override
  State<TextFormField2> createState() => _TextFormField2State();
}

class _TextFormField2State extends State<TextFormField2> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.onBlur != null) {
      _textFieldFocusNode.addListener(_handleFocusChange);
    }
    if (mounted) {
      initValues();
    }
  }

  void _handleFocusChange() {
    if (!_textFieldFocusNode.hasFocus) {
      // Esto se ejecuta cuando el campo PIERDE el foco
      print('El campo perdió el foco');
      _onBlur();
      // Aquí puedes agregar validaciones u otras lógicas
    } else {
      log("Activando el foco en input ...");
    }
  }

  @override
  void didUpdateWidget(covariant TextFormField2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultValue != oldWidget.defaultValue ||
        widget.customDefaultValue != oldWidget.customDefaultValue) {
      if (mounted) {
        initController();
      }
    }

    var form1 = widget.formSave ?? {};
    var form2 = oldWidget.formSave ?? {};

    var newValue = form1[widget.formKey ?? '']?.value;
    var oldValue = form2[oldWidget.formKey ?? '']?.value;
    if (widget.formKey == 'conductorLicencia') {
      log("validando");
      log('${widget.formKey}: nuevo valor $newValue');
      log('${widget.formKey}: anterior valor $oldValue');
    }
    if (newValue != oldValue) {
      print('cambio  de estado en input $oldValue=>$newValue');
      log("ha cambiado el valor en el textinput:: ${widget.formSave![widget.formKey]?.value}");
      if (mounted) {
        initController();
      }
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _textFieldFocusNode.removeListener(_handleFocusChange);
      _textFieldFocusNode.dispose();
      _controller.dispose();
    }
    super.dispose();
  }

  void _onBlur() {
    var inputText = _controller.text;
    if (widget.onBlur != null) {
      widget.onBlur!(inputText);
    }
  }

  void initValues() {
    initController();
  }

  void initController() {
    dynamic letValue = '';
    if (widget.defaultValue != null) {
      letValue = widget.defaultValue;
    } else if (widget.customDefaultValue != null) {
      letValue = widget.customDefaultValue!();
    } else if (widget.formSave != null && widget.formKey != null) {
      letValue = widget.formSave![widget.formKey]?.value ?? '';
    }
    if (widget.cantidadDecimales != null) {
      letValue = double.tryParse('${letValue ?? 0}')
          ?.toStringAsFixed(widget.cantidadDecimales ?? 2);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.text =
            widget.cantidadDecimales != null ? letValue : letValue.toString();
      }
    });
  }

  void _handleChangeValue(String? key, dynamic value) {
    if (widget.formSave != null && widget.formKey != null) {
      widget.formSave![widget.formKey!] =
          GenericItemForm(key: widget.formKey!, value: value);
    }
    dynamic valueParse = value;

    if (widget.type == TypeTextField.int) {
      valueParse = int.parse((value == "" ? 0 : value).toString());
    } else if (widget.type == TypeTextField.decimal) {
      valueParse = double.tryParse((value == "" ? 0 : value))
          ?.toStringAsFixed(widget.cantidadDecimales ?? 2);
    } else if (widget.type == TypeTextField.string) {
      valueParse = value;
    } else {
      valueParse = valueParse.toString();
    }

    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  void setController(String valor) {
    _controller.text = valor;
  }

  TextEditingController getController() {
    return _controller;
  }

  List<Widget> generateContent() {
    List<Widget> list = [];

    if (widget.label != null) {
      list.add(Text(
        widget.label ?? "",
        style: widget.titleTextStyle,
      ));
    }

    list.add(SizedBox(
      child: TextFormField(
        validator: widget.validator,
        enabled: widget.enabled ?? true,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.type == TypeTextField.decimal
            ? const TextInputType.numberWithOptions(
                signed: false, decimal: true)
            : widget.type == TypeTextField.int
                ? TextInputType.number
                : null,
        inputFormatters: widget.type == TypeTextField.decimal
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ]
            : widget.type == TypeTextField.int
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
        onChanged: (value) => _handleChangeValue(widget.formKey, value),
        controller: getController(),
        focusNode: widget.focusNode ?? _textFieldFocusNode,
        autofocus: widget.autofocus ?? false,
        decoration: widget.decoration != null
            ? widget.decoration!.copyWith(
                filled: widget.colorBackground != null ||
                    (widget.decoration?.filled ?? false),
                fillColor:
                    widget.colorBackground ?? widget.decoration!.fillColor,
              )
            : inputDecorationForm2(
                hintText: widget.hint ?? '',
                required: widget.required,
              ).copyWith(
                filled: widget.colorBackground != null,
                fillColor: widget.colorBackground,
              ),
      ),
    ));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: generateContent(),
      ),
    );
  }
}
