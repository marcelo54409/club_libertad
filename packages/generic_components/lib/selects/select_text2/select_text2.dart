import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

abstract class SelectText2Operations {
  Map<String, dynamic> toJson();
}

class SelectText2<T extends SelectText2Operations> extends StatefulWidget {
  final bool? isEnabled;

  final bool? enableSearch;
  final ValueChanged<dynamic>? onChanged;
  final FormFieldValidator<String>? validator;

  final String keyValue; //id
  final String keyLabel; //nombre
  final String Function(T data)? customLabel;

  final String? label;
  final TextStyle? labelStyle;
  final String? hint;
  final Map<String, GenericItemForm>? formSave;
  final String? formKey;
  final dynamic defaultValue;
  final TextStyle? textStyle;
  final List<T> data;
  final bool? required;
  final bool? search;
  final bool? showClear;
  final double? width;
  final int? dropDownItemCount;
  // final TextStyle? textStyle;

  final void Function(T? value)? onSelected;
  final List<T> Function()? parseData;

  const SelectText2({
    Key? key,
    this.isEnabled,
    this.parseData,
    this.enableSearch,
    this.onChanged,
    this.customLabel,
    required this.keyValue,
    this.defaultValue,
    this.labelStyle,
    this.label,
    this.width,
    this.onSelected,
    this.textStyle,
    this.formSave,
    this.formKey,
    this.hint,
    this.required,
    this.search,
    this.showClear,
    required this.data,
    required this.keyLabel,
    this.dropDownItemCount,
    this.validator,
    // this.textStyle,
  }) : super(key: key);

  @override
  State<SelectText2> createState() => _SelectText2State<T>();
}

class _SelectText2State<T extends SelectText2Operations>
    extends State<SelectText2<T>> {
  late SingleValueDropDownController controller;
  List<DropDownValueModel> dropDownList = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = SingleValueDropDownController(data: null);

    controller.addListener(() {
      if (controller.dropDownValue == null) {
        handleChange(null);
      }
    });

    // Inicializamos fuera del setState
    inicializarLista();
    inicializarControllers();
    _isInitialized = true;
  }

  @override
  void didUpdateWidget(covariant SelectText2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (mounted) {
      // Solo actualizamos si hay cambios relevantes
      bool needsUpdate = false;

      // Verificamos si los datos han cambiado
      if (widget.data != oldWidget.data &&
          (widget.parseData == null || oldWidget.parseData == null)) {
        log("El state select2 data cambios regs ${widget.formKey}: ${widget.data.length}");
        needsUpdate = true;
      }

      // Verificamos si parseData ha cambiado
      if (widget.parseData != oldWidget.parseData) {
        needsUpdate = true;
      }

      // Si necesitamos actualizar la lista
      if (needsUpdate) {
        inicializarLista();
        Map<String, dynamic> tempForm = oldWidget.formSave ?? {};
        if (tempForm[oldWidget.formKey ?? ''] != null ||
            widget.defaultValue != null ||
            oldWidget.defaultValue != null) {
          inicializarControllers();
        }
      }

      // Verificamos cambios en el valor seleccionado
      bool valueChanged = false;

      if (widget.formSave != null &&
          widget.formKey != null &&
          oldWidget.formSave != null &&
          oldWidget.formKey != null) {
        if (widget.formSave![widget.formKey!]?.value !=
            oldWidget.formSave![oldWidget.formKey]?.value) {
          log("El state select2 default a cambiado ${widget.formKey}: ${widget.formSave![widget.formKey]?.value}");
          valueChanged = true;
        }
      }

      if (widget.defaultValue != oldWidget.defaultValue) {
        log("El state select2 default a cambiado ");
        valueChanged = true;
      }

      // Si el valor ha cambiado
      if (valueChanged) {
        inicializarControllers();
      }
    }
  }

  void inicializarLista() {
    print("El state inicial regs : ${widget.data.length}");
    List<DropDownValueModel> selectsList = [];
    List<T> finalData = [];

    if (widget.parseData != null) {
      finalData = widget.parseData!();
    } else {
      finalData = widget.data ?? [];
    }

    for (T itemReg in finalData) {
      Map<String, dynamic> itemMap = itemReg.toJson();
      log("option select=> ${itemMap.toString()}");
      var item = DropDownValueModel(
          name: widget.customLabel != null
              ? widget.customLabel!(itemReg)
              : itemMap[widget.keyLabel],
          value: itemMap[widget.keyValue]);
      selectsList.add(item);
    }

    if (mounted) {
      setState(() {
        dropDownList = selectsList;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void inicializarControllers() {
    if (!mounted) return;

    DropDownValueModel? modelDefault;
    List<T> finalData = [];

    if (widget.parseData != null) {
      finalData = widget.parseData!();
    } else {
      finalData = widget.data ?? [];
    }

    for (dynamic itemReg in finalData) {
      Map<String, dynamic> itemMap = itemReg.toJson();

      if (widget.defaultValue != null) {
        if (itemMap[widget.keyValue] != null &&
            itemMap[widget.keyValue] == widget.defaultValue) {
          modelDefault = DropDownValueModel(
              name: itemMap[widget.keyLabel], value: itemMap[widget.keyValue]);
          break;
        }
      } else if (widget.formKey != null && widget.formSave != null) {
        var valueForm = widget.formSave![widget.formKey!]?.value;
        if (valueForm != null && itemMap[widget.keyValue] == valueForm) {
          log("registro encontrado $itemMap");
          modelDefault = DropDownValueModel(
              name: itemMap[widget.keyLabel], value: itemMap[widget.keyValue]);
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        controller.dropDownValue = modelDefault;
      });
    }
  }

  void handleChange(dynamic value) {
    if (!mounted) return;

    log("valor seleccionado $value");

    dynamic valueSelect = '';
    if (value == null) {
      valueSelect = null;
    } else if (value == '') {
      valueSelect = value;
    } else {
      valueSelect = value.value;
    }

    T? findRegistro;

    if (valueSelect != null) {
      for (T itemReg in widget.data) {
        Map<String, dynamic> itemMap = itemReg.toJson();
        if (itemMap[widget.keyValue] != null &&
            itemMap[widget.keyValue] == valueSelect) {
          findRegistro = itemReg;
          break;
        }
      }
    }

    if (widget.formKey != null && widget.formSave != null) {
      widget.formSave![widget.formKey!] =
          GenericItemForm(key: widget.formKey!, value: valueSelect);
    }

    if (widget.onSelected != null) {
      widget.onSelected!(findRegistro);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    double padding = 12.0;

    // NO usamos DateTime.now() en la key, eso causa reconstrucciones constantes
    return SizedBox(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null)
              Text(
                widget.label ?? "",
                style: widget.labelStyle,
              ),
            DropDownTextField(
              // Usamos una key estable
              key: ObjectKey(widget.formKey ?? widget.keyValue),
              controller: controller,
              clearOption: true,
              searchShowCursor: true,
              isEnabled: widget.isEnabled ?? true,
              enableSearch: widget.enableSearch ?? true,
              padding: EdgeInsets.all(padding),
              searchAutofocus: true,
              textStyle: widget.textStyle,
              textFieldDecoration: InputDecoration(
                hintText: widget.hint ?? "Seleccione",
                contentPadding: EdgeInsets.all(padding),
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              dropDownItemCount: widget.dropDownItemCount ?? 3,
              dropDownList: dropDownList,
              onChanged: handleChange,
              // textStyle: widget.textStyle,
              // 👈 Aplica aquí

              validator: widget.validator ??
                  (value) {
                    if (widget.required != true) return null;
                    if (value == null || value.isEmpty) {
                      return 'Seleccione una opcion';
                    }
                    return null;
                  },
            ),
          ],
        ));
  }
}
