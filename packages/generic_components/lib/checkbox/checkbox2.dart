import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

class Checkbox2 extends StatefulWidget {
  final String? label;
  final String? hint;
  final Map<String, GenericItemForm>? formSave;
  final String? formKey;
  final bool? defaultValue;
  final bool? Function()? customDefaultValue;
  final bool? autofocus;
  final bool? showClear;
  final bool? enabled;
  final bool? readOnly;

  final void Function(bool value)? onChange;

  const Checkbox2(
      {super.key,
      this.defaultValue,
      this.customDefaultValue,
      this.enabled,
      this.readOnly,
      this.label,
      this.formSave,
      this.formKey,
      this.hint,
      this.showClear,
      this.onChange,
      this.autofocus});

  @override
  State<Checkbox2> createState() => _Checkbox2State();
}

class _Checkbox2State extends State<Checkbox2> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initValues();
    }
  }

  @override
  void didUpdateWidget(covariant Checkbox2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultValue != oldWidget.defaultValue ||
        widget.customDefaultValue != oldWidget.customDefaultValue) {
      if (mounted) {
        initValues();
      }
    }

    if (widget.formKey != null && widget.formSave != null) {

      var newValue = widget.formSave![widget.formKey]?.value;
      var oldValue = oldWidget.formSave![oldWidget.formKey]?.value;
      if(newValue!=oldValue){
        log("ha cambiado el valor en el checkbox:: ${widget.formSave![widget.formKey]?.value}");
        if (mounted) {
          initValues();
        }
      }


    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initValues() {
    if(widget.formSave!=null && widget.formKey!=null){
      setState(() {
        isChecked=widget.formSave![widget.formKey!]?.value??false;
      });
    }

  }

  void handleChange(bool? newValue) {
    if(widget.formSave!=null && widget.formKey!=null){
      widget.formSave![widget.formKey!]= GenericItemForm(key: widget.formKey!, value: newValue??false);
    }
    if(widget.onChange!=null){
      widget.onChange!(newValue??false);
    }
    setState(() {
      isChecked = newValue ?? false; // Actualiza el estado
    });
  }

  Widget generateContent() {
    List<Widget> list = [];

    if (widget.label != null) {
      list.add(Text(
        widget.label ?? "",
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label ?? '',
            // style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 1),
        ], // Espacio entre el checkbox y el texto
        Checkbox(

          value: isChecked, // Valor actual del checkbox
          onChanged:(widget.enabled??true)? handleChange:null
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return generateContent();
  }
}
