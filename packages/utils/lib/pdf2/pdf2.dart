import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/src/pdf/document.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:utils/toasted/toasted.dart';

class PDF2Config {
  String? title;
  BuildContext context;
  PDF2Config({this.title, required this.context});
}

class PDF2 {
  // Propiedades del singleton
  final PDF2Config? config;
  pw.Document? _pdf;

  Map<int, pw.Page> _pages = {};
  int _indexPage = 0;

  File? _fileSaved;

  // Instancia única
  static PDF2? _instance;

  // Constructor privado
  PDF2._privateConstructor(this.config);

  // Método para inicializar o recuperar la instancia
  static PDF2 initialize(PDF2Config config) {
    _instance ??= PDF2._privateConstructor(config);
    _instance?._setDocument();
    return _instance!;
  }

  // Método para acceder a la instancia sin inicializarla
  static PDF2 get instance {
    if (_instance == null) {
      throw Exception(
          'El singleton no ha sido inicializado. Usa initialize primero.');
    }
    return _instance!;
  }

  void _setDocument() {
    _pdf = pw.Document();
  }

  PdfDocument? getDocument() {
    return _pdf?.document;
  }

  // Ejemplo de método en la clase

  void addPage(pw.Page page) {
    try {
      if (_pdf == null) {
        Toasted.error(message: "pdf is null inicializar").show();
        return;
      }
      if (_fileSaved != null) {
        Toasted.error(message: "El Documento ya existe").show();
        return;
      }

      _indexPage++;
      _pages[_indexPage] = page;
      _pdf?.addPage(page);
    } catch (e) {
      Toasted.error(message: 'Error al generar archivo: ${e.toString()}')
          .show();
      log('Error al generar archivo: ${e.toString()}');
      rethrow;
    }
  }

  Future<File?> savedFile(String? filename) async {
    if (_pdf == null) {
      Toasted.error(message: "PDF ES NULL").show();
      return null;
    } else {
      final name = filename ?? config?.title ?? 'example.pdf';

      // Usar directorio temporal
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/$name";

      final file = File(filePath);
      await file.writeAsBytes(await _pdf!.save());
      _fileSaved = file;

      log('PDF guardado en: ${file.path}');

      // Mostrar opciones del sistema para abrir/compartir el archivo
      Share.shareXFiles([XFile(_fileSaved!.path)],
          subject: 'Documento PDF', text: 'Ver documento generado');

      return file;
    }
  }

  void compartirPDF() {
    if (_fileSaved == null) {
      Toasted.error(
              message: "No se puede compartir este archivo. guardar primero")
          .show();
      log("No se puede compartir este archivo. guardar primero");
      return;
    }
    Share.shareXFiles([XFile(_fileSaved!.path)],
        text: '¡Revisa este archivo PDF!');
  }

  Future<void> imprimirPDF() async {
    if (_fileSaved == null) {
      Toasted.error(
              message: "No se puede compartir este archivo. guardar primero")
          .show();
      log("No se puede compartir este archivo. guardar primero");
      return;
    }
    final fileBytes = await File(_fileSaved!.path).readAsBytes();

    // Abre el diálogo de impresión
    await Printing.layoutPdf(
      onLayout: (format) async => fileBytes,
    );
  }

  Future<void> openPDF() async {
    if (_fileSaved == null) {
      Toasted.error(
              message: "No se puede compartir este archivo. guardar primero")
          .show();
      log("No se puede compartir este archivo. guardar primero");
      return;
    }
    final fileBytes = await File(_fileSaved!.path).readAsBytes();

    // Abre el diálogo de impresión
    await OpenFile.open(_fileSaved!.path);
    print('PDF guardado en: ${_fileSaved!.path}');
  }

  bool existeFile() {
    bool existe = false;
    if (_fileSaved == null) {
      Toasted.error(message: "No se pudo generar el archivo PDF.").show();
      log("No se pudo generar el archivo PDF.");
      return false;
    }

    if (File(_fileSaved!.path).existsSync()) {
      Toasted.success(message: "El archivo  está listo para mostrarse.").show();
      log("El archivo existe y está listo para mostrarse.");
      existe = true;
    } else {
      Toasted.error(
              message:
                  "El archivo NO se encuentra en la ruta: ${_fileSaved!.path}")
          .show();
      existe = false;
    }
    return existe;
  }

  /* Future<PermissionStatus> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      log("Permiso concedido");
      Toasted.success(message: "Permiso para pdf concedido").show();
      // Aquí puedes llamar a la función para generar y guardar el PDF
    } else if (status.isDenied) {
      log("Permiso denegado");
      Toasted.error(message: "Permiso para pdf ha sido denegado").show();
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      print("Permiso permanentemente denegado ⚠️");
      _showSettingsDialog();
    }
    return status;
  }*/
/*
  void _showPermissionDialog() {
    showDialog(
      context: config!.context,
      builder: (context) => AlertDialog(
        title: Text("Permiso Requerido"),
        content: Text(
            "Esta app necesita acceso al almacenamiento para guardar el PDF."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await requestStoragePermission();
              // _showSettingsDialog(); // Volver a pedir permiso
            },
            child: Text("Intentar de nuevo"),
          ),
        ],
      ),
    );
  }
*/
/*
  void _showSettingsDialog() {
    showDialog(
      context: config!.context,
      builder: (context) => AlertDialog(
        title: Text("Permiso Denegado Permanentemente"),
        content:
            Text("Debes habilitar el permiso manualmente en Configuración."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings(); // Abre la configuración de la app
            },
            child: Text("Ir a Configuración"),
          ),
        ],
      ),
    );
  }*/
  // Future<PermissionStatus> requestStoragePermission() async {
  //   // Verifica el estado del permiso
  //   var status = await Permission.storage.status;

  //   // if (status.isDenied) {
  //     // Solicita el permiso si está denegado
  //     if (await Permission.storage.request().isDenied) {
  //       log("Permiso concedido");
  //       Toasted.success(message: "Permiso para pdf concedido").show();
  //     } else {
  //       log("Permiso denegado");
  //       Toasted.error(message: "Permiso para pdf ha sido denegado").show();
  //       await openAppSettings();
  //     }
  //   // } else if (status.isPermanentlyDenied) {
  //   //   // Si el usuario bloquea permanentemente el permiso, abre la configuración
  //   //   await openAppSettings();
  //   // }
  //   return status;
  // }

  void close() {
    _pdf = pw.Document();
    _indexPage = 0;
    _pages = {};
    _fileSaved = null;
  }
// Future<SfPdfViewer?> viewPDF(String? filename) async {
//   File? file = await savedFile(filename);
//   if(file!=null) {
//     return SfPdfViewer.file(file);
//   } else {
//     return null;
//   }
// }
}
