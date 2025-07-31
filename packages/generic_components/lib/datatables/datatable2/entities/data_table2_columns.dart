import 'package:flutter/cupertino.dart';

class DataTable2Columns<T> {
  String dataKey;
  String? label;
  double? widthColFixed;
  Widget Function(T? item, [int? index])?
      customCellData; //para personalizar las celdas de losc uerpos
  Widget Function()?
      customCellHeader; //para personalizar las celdas de las cabeceras
  DataTable2Columns(
      {required this.dataKey,
      this.widthColFixed,
      this.label,
      this.customCellData,
      this.customCellHeader});
}
