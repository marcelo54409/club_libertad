class GenericItemForm {
  String? key;
  dynamic value;
  GenericItemFormOptions? options;
  bool? editing;
  GenericItemForm({
    this.key,
    this.value,
    this.options,
    this.editing,
  });
  @override
  String toString() {
    return 'GenericItemForm(key: $key, value: $value, editing: $editing, options: $options)';
  }
}

/*
* Descripcion: GenericItemFormOptions
* typeData: tipo de dato del atributo es opcional
*
*/
enum TypeData { decimal, string, int }

/*
* hidden: oculta la propiedad en el formulario
* */
class GenericItemFormOptions {
  bool? isRequired;
  TypeData? typeData;
  bool? hidden;
  String? label;
  String? hintText;
  int? index;

  GenericItemFormOptions(
      {this.isRequired,
      this.index,
      this.typeData,
      this.hidden,
      this.label,
      this.hintText});
  @override
  String toString() {
    return 'GenericItemFormOptions(isRequired: $isRequired, typeData: $typeData, hidden: $hidden, label: $label, hintText: $hintText, index: $index)';
  }
}

/*
* map<key,GenericForm>
*
* */
