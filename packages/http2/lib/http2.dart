import 'dart:convert';

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http2/entities/auth/user_result.dart';
import 'package:http2/entities/response_api_dto.dart';
import 'package:http2/entities/result_response.dart';
import 'package:http2/entities/xml_http_request_config.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class Http2 {
  String? baseURL;
  String? url;
  bool? disabledAuthBearer;

  XMLHTTPRequestConfig? defaultConfig;
  dynamic client;
  bool _localMode = false;
  int _timeout = 60;
  BuildContext? contextProp;
  bool? mountedProp;

  Http2(
      {this.url,
      this.disabledAuthBearer,
      this.baseURL,
      this.defaultConfig,
      this.contextProp,
      this.mountedProp}) {
    _initEnv();
  }

  Future<void> _initEnv() async {
    await dotenv.load(fileName: ".env");

    String? localMode = dotenv.get('HTTP2_LOCAL_MODE');
    String? timeout = dotenv.get('HTTP2_TIMEOUT');

    _localMode = bool.parse(localMode);

    if (timeout != null) {
      _timeout = int.parse(timeout);
    }
  }

  Future<Map<String, dynamic>> localDataStorage() async {
// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiBaseURL = prefs.getString('api_baseURL');
    final dynamic userLogin = prefs.getString('user');
    final String? token = prefs.getString('token');
    Map<String, String?> dataStorage = {
      'apiBaseURL': apiBaseURL,
      'userLogin': userLogin,
      'token': token
    };
    return dataStorage;
  }

  String parseUrlParams(String url, UserResult? userResult, String? params,
      {bool omitGlobalParams = false}) {
    // configuraciones de las url parametrizadas
    //informacion de la empresa del usuario
    String paramsStr = "";

    if (!omitGlobalParams) {
      if (!url.contains('username')) {
        if (!url.contains('?')) {
          paramsStr = '?username=${userResult?.username}';
        } else {
          paramsStr = '&username=${userResult?.username}';
        }
        url = '$url$paramsStr';
      }
      if (!url.contains('empresaID') || !url.contains('empresaId')) {
        if (!url.contains('?')) {
          paramsStr = '?empresaID=${userResult?.empresaId ?? 0}';
        } else {
          paramsStr = '&empresaID=${userResult?.empresaId ?? 0}';
        }
        url = '$url$paramsStr';
      }
      //para el hostname tomamos los id de los dispositivos
      if (!paramsStr.contains('?') || !url.contains('hostname')) {
        if (!url.contains('?')) {
          paramsStr = '?hostname=${userResult?.deviceID}';
        } else {
          paramsStr = '&hostname=${userResult?.deviceID}';
        }
        url = '$url$paramsStr';
      }
      if (!paramsStr.contains('?') || !url.contains('userID')) {
        if (!url.contains('?')) {
          paramsStr = '?userID=${userResult?.userID}';
        } else {
          paramsStr = '&userID=${userResult?.userID}';
        }
        url = '$url$paramsStr';
      }
    }
    return url;
  }

  Future<ResultResponse> get(
      {required String url,
      XMLHTTPRequestConfig? requestConfig,
      String? params,
      String? setBaseURL,
      bool? mounted,
      BuildContext? context,
      bool omitGlobalParams = false,
      bool ignoreToasted = false}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);
    String urlCompleta = '';
    if (setBaseURL != null) {
      urlCompleta = setBaseURL;
    } else if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    print('toasted $ignoreToasted');
    final token = localStorage["token"];

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      //  'authorization': 'Bearer $token'
    };
    if (disabledAuthBearer == null || disabledAuthBearer == false) {
      headers['authorization'] = 'Bearer $token';
    }
    var dataUser = localStorage['userLogin'];
    UserResult? userResult;
    if (dataUser != null) {
      var parseData = jsonDecode(dataUser);
      userResult = UserResult.fromJson(parseData["data"]);
    }

    urlCompleta = parseUrlParams(urlCompleta, userResult, params,
        omitGlobalParams: omitGlobalParams);

    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      // http.Response response = await http.get(url0);
      // print("url api: $urlApi");
      http.Response response;
      if (_localMode) {
// esta configuracion es solo para cuando se usa en modo local
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final httpClient = IOClient(client);
        response = await httpClient
            .get(urlApi, headers: headers)
            .timeout(Duration(seconds: _timeout));
      } else {
//esta se usa para conexion en produccion
        response = await http
            .get(urlApi, headers: headers)
            .timeout(Duration(seconds: _timeout));
      }

      if (response.statusCode == 401) {
        resultResponse.statusCode = 401;
        resultResponse.message = "Sesión Expirada";
        resultResponse.data = null;
        LocalStorage store = await LocalStorage.initialize();
        store.deleteItems(["token", "user"]);

        if (mountedProp == true || mounted == true) {
          if (contextProp != null || context != null) {
            GoRouter.of((contextProp ?? context)!).go('/login');
            //context?.go('/login');
            return resultResponse;
          }
        }
      } else {
        // print(response);
//revisamos la informacion de estructura de la api
        var responseData = jsonDecode(response.body);
        log("informacion obtenida de $urlApi");
        log(responseData.toString());
        var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);
        if (responseData["status"] == 400) {
          resultResponse.statusCode = responseData["status"];
          resultResponse.message = responseData["message"] ??
              "error al ejecutar consulta en ${urlApi}";
          if (_localMode && !ignoreToasted) {
            Toasted(
              toastLength: ToastLenght.lengthLong,
              message: '$urlCompleta=>${resultResponse.message}',
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ).show();
          }
        } else if (responseData["status"] == 200) {
          resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
          resultResponse.message =
              parseDataResponse.data?.message ?? "Obteniendo información";
          resultResponse.data = parseDataResponse.data?.data;
        }
      }
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      if (_localMode && !ignoreToasted) {
        Toasted(
          toastLength: ToastLenght.lengthLong,
          message: '$urlCompleta=>${resultResponse.message}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        ).show();
      }
      // rethrow;
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }

  Future<ResultResponse> post(
      {required String url,
      bool? mounted,
      String? setBaseURL,
      BuildContext? context,
      required dynamic body,
      XMLHTTPRequestConfig? requestConfig,
      bool? useFormData,
      bool ignoreToasted = false}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    final token = localStorage["token"];

    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);

    String urlCompleta = '';
    if (setBaseURL != null) {
      urlCompleta = setBaseURL;
    } else if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    var dataUser = localStorage['userLogin'];
    UserResult? userResult;
    if (dataUser != null) {
      var parseData = jsonDecode(dataUser);
      userResult = UserResult.fromJson(parseData["data"]);
    }

    if (requestConfig?.omitGlobalParams != true &&
        userResult != null &&
        body is Map<String, dynamic>) {
      body["empresaID"] = userResult.empresaId!;
      body["deviceID"] = userResult.deviceID!;
      body["username"] = userResult.username.trim();
      body["hostname"] = userResult.deviceID.toString();
      body["userID"] = userResult.userID.toString().trim();
    }

    Map<String, String> headers = {
      'accept': 'application/json',
    };

    if (useFormData != true) {
      headers['content-type'] = 'application/json';
      log('ENVIANDO SOLICITUD COMO JSON ');
    } else {
      log(' ENVIANDO SOLICITUD COMO FORM-DATA ');
    }

    if (disabledAuthBearer == null || disabledAuthBearer == false) {
      headers['authorization'] = 'Bearer $token';
    }

    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      http.Response response;

      if (_localMode) {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final httpClient = IOClient(client);

        if (useFormData == true) {
          var request = http.MultipartRequest('POST', urlApi);

          request.headers.addAll(headers);

          await _addFieldsAndFilesToRequest(request, body);

          log('Campos de form-data: ${request.fields}');
          log('Archivos adjuntos: ${request.files.length}');

          var streamedResponse = await httpClient
              .send(request)
              .timeout(Duration(seconds: _timeout));
          response = await http.Response.fromStream(streamedResponse);
        } else {
          var bodyJson = jsonEncode(body);
          log('data enviada: ${bodyJson.toString()}');
          log("informacion enviada a $urlApi");
          log(bodyJson);

          response = await httpClient
              .post(urlApi, body: bodyJson, headers: headers)
              .timeout(Duration(seconds: _timeout));
        }
      } else {
        if (useFormData == true) {
          var request = http.MultipartRequest('POST', urlApi);
          request.headers.addAll(headers);
          await _addFieldsAndFilesToRequest(request, body);

          log('Campos de form-data: ${request.fields}');
          log('Archivos adjuntos: ${request.files.length}');
          var streamedResponse =
              await request.send().timeout(Duration(seconds: _timeout));
          response = await http.Response.fromStream(streamedResponse);
        } else {
          var bodyJson = jsonEncode(body);
          log('data enviada: ${bodyJson.toString()}');
          log("informacion enviada a $urlApi");
          log(bodyJson);

          response = await http
              .post(urlApi, body: bodyJson, headers: headers)
              .timeout(Duration(seconds: _timeout));
        }
      }

      log('Status code: ${response.statusCode}');
      log('Respuesta completa: ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}');
      log('toasted $ignoreToasted');

      try {
        if (response.statusCode == 401) {
          resultResponse.statusCode = 401;
          resultResponse.message = "Sesión Expirada";
          resultResponse.data = null;
          LocalStorage store = await LocalStorage.initialize();
          store.deleteItems(["token", "user"]);
          if (mountedProp == true || mounted == true) {
            if (contextProp != null || context != null) {
              context?.go('/login');
              return resultResponse;
            }
          }
        } else {
          var responseData = jsonDecode(response.body);
          var parseDataResponse =
              ResponseApiDTO<dynamic>.fromJson(responseData);

          if (response.statusCode == 200) {
            resultResponse.statusCode =
                parseDataResponse.data?.statusCode ?? 400;
            resultResponse.message =
                parseDataResponse.data?.message ?? "Registrando información";
            resultResponse.data = parseDataResponse.data?.data;
          } else if (response.statusCode == 500 || response.statusCode == 400) {
            resultResponse.statusCode = response.statusCode;
            resultResponse.message = parseDataResponse.message ?? '-';
            resultResponse.data = null;
          }
        }
      } catch (jsonError) {
        log('Error al decodificar JSON: $jsonError');
        resultResponse.statusCode = response.statusCode;
        resultResponse.message = response.body.substring(
            0, response.body.length > 100 ? 100 : response.body.length);
        resultResponse.data = null;
      }
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      if (!ignoreToasted) {
        Toasted(
          toastLength: ToastLenght.lengthLong,
          message: '$urlCompleta=>${ex.toString()} ${ignoreToasted}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        ).show();
      }
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }

  Future<void> _addFieldsAndFilesToRequest(
      http.MultipartRequest request, Map<String, dynamic> body) async {
    for (var entry in body.entries) {
      String key = entry.key;
      dynamic value = entry.value;

      if (value is File) {
        try {
          List<int> bytes = await value.readAsBytes();
          String fileName = value.path.split('/').last;

          request.files.add(
              http.MultipartFile.fromBytes(key, bytes, filename: fileName));
          log('Agregado archivo: $fileName al campo $key');
        } catch (e) {
          log(' Error al procesar archivo para el campo $key: $e');
          request.fields[key] = value.path;
        }
      } else if (value is List) {
        bool containsFiles = false;

        for (var item in value) {
          if (item is File) {
            containsFiles = true;
            break;
          }
        }

        if (containsFiles) {
          for (int i = 0; i < value.length; i++) {
            var item = value[i];

            if (item is File) {
              try {
                List<int> bytes = await item.readAsBytes();
                String fileName = item.path.split('/').last;
                String fieldName = key.contains("[") ? key : "$key[$i]";

                request.files.add(http.MultipartFile.fromBytes(fieldName, bytes,
                    filename: fileName));
                log('Agregado archivo[$i]: $fileName al campo $fieldName');
              } catch (e) {
                log('Error al procesar archivo en lista para campo $key[$i]: $e');
              }
            } else {
              String fieldName = key.contains("[") ? key : "$key[$i]";
              request.fields[fieldName] = item?.toString() ?? '';
            }
          }
        } else {
          request.fields[key] = jsonEncode(value);
        }
      } else {
        request.fields[key] = value?.toString() ?? '';
      }
    }
  }

  Future<ResultResponse> put(
      {required String url,
      String? setBaseURL,
      required Map<String, dynamic> body,
      bool? mounted,
      BuildContext? context,
      XMLHTTPRequestConfig? requestConfig,
      bool? useFormData}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    final token = localStorage["token"];

    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);

    String urlCompleta = '';
    if (setBaseURL != null) {
      urlCompleta = setBaseURL;
    } else if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    var dataUser = localStorage['userLogin'];
    UserResult? userResult;
    if (dataUser != null) {
      var parseData = jsonDecode(dataUser);
      userResult = UserResult.fromJson(parseData["data"]);
    }

    if (userResult != null) {
      body["empresaID"] = userResult.empresaId!;
      body["deviceID"] = userResult.deviceID!;
      body["username"] = userResult.username.trim();
      body["hostname"] = userResult.deviceID.toString();
      body["userID"] = userResult.userID.toString().trim();
    }

    Map<String, String> headers = {
      'accept': 'application/json',
    };

    if (useFormData != true) {
      headers['content-type'] = 'application/json';
      log('ENVIANDO SOLICITUD COMO JSON ');
    } else {
      log(' ENVIANDO SOLICITUD COMO FORM-DATA ');
    }

    if (disabledAuthBearer == null || disabledAuthBearer == false) {
      headers['authorization'] = 'Bearer $token';
    }

    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      http.Response response;

      if (_localMode) {
        // esta configuracion es solo para cuando se usa en modo local
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final httpClient = IOClient(client);

        if (useFormData == true) {
          var request = http.MultipartRequest('PUT', urlApi);
          request.headers.addAll(headers);
          await _addFieldsAndFilesToRequest(request, body);

          log('Campos de form-data: ${request.fields}');
          log('Archivos adjuntos: ${request.files.length}');

          var streamedResponse = await httpClient
              .send(request)
              .timeout(Duration(seconds: _timeout));
          response = await http.Response.fromStream(streamedResponse);
        } else {
          var bodyJson = jsonEncode(body);
          log('data enviada: ${bodyJson.toString()}');
          log("informacion enviada a $urlApi");
          log(bodyJson);

          response = await httpClient
              .put(urlApi, body: bodyJson, headers: headers)
              .timeout(Duration(seconds: _timeout));
        }
      } else {
        //esta se usa para conexion en produccion
        if (useFormData == true) {
          var request = http.MultipartRequest('PUT', urlApi);
          request.headers.addAll(headers);
          await _addFieldsAndFilesToRequest(request, body);

          log('Campos de form-data: ${request.fields}');
          log('Archivos adjuntos: ${request.files.length}');

          var streamedResponse =
              await request.send().timeout(Duration(seconds: _timeout));
          response = await http.Response.fromStream(streamedResponse);
        } else {
          var bodyJson = jsonEncode(body);
          log('data enviada: ${bodyJson.toString()}');
          log("informacion enviada a $urlApi");
          log(bodyJson);

          response = await http
              .put(urlApi, body: bodyJson, headers: headers)
              .timeout(Duration(seconds: _timeout));
        }
      }

      log('Status code: ${response.statusCode}');
      log('Respuesta completa: ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}');

      try {
        if (response.statusCode == 401) {
          resultResponse.statusCode = 401;
          resultResponse.message = "Sesión Expirada";
          resultResponse.data = null;
          LocalStorage store = await LocalStorage.initialize();
          store.deleteItems(["token", "user"]);
          if (mountedProp == true || mounted == true) {
            if (contextProp != null || context != null) {
              GoRouter.of((contextProp ?? context)!).go('/login');
              return resultResponse;
            }
          }
        } else {
          var responseData = jsonDecode(response.body);
          var parseDataResponse =
              ResponseApiDTO<dynamic>.fromJson(responseData);

          if (response.statusCode == 200) {
            resultResponse.statusCode =
                parseDataResponse.data?.statusCode ?? 400;
            resultResponse.message =
                parseDataResponse.data?.message ?? "actualizando información";
            resultResponse.data = parseDataResponse.data?.data;
          } else if (response.statusCode == 500 || response.statusCode == 400) {
            resultResponse.statusCode = response.statusCode;
            resultResponse.message = parseDataResponse?.message ?? '-';
            resultResponse.data = null;
          }
        }
      } catch (jsonError) {
        log('Error al decodificar JSON: $jsonError');
        resultResponse.statusCode = response.statusCode;
        resultResponse.message = response.body.substring(
            0, response.body.length > 100 ? 100 : response.body.length);
        resultResponse.data = null;
      }
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      Toasted(
              toastLength: ToastLenght.lengthLong,
              message: '$urlCompleta=>${ex.toString()}',
              backgroundColor: Colors.red,
              textColor: Colors.white)
          .show();
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }

  Future<ResultResponse> delete(
      {required String url,
      String? setBaseURL,
      Map<String, dynamic>? body,
      bool? mounted,
      BuildContext? context,
      XMLHTTPRequestConfig? requestConfig}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);

    String urlCompleta = '';
    if (setBaseURL != null) {
      urlCompleta = setBaseURL;
    } else if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      var bodyJson = jsonEncode(body);
      print('data enviada: ${bodyJson.toString()}');
      // http.Response response = await http.get(url0);
      var response = await http
          .delete(
            urlApi,
            headers: {
              'Content-Type': 'application/json',
              // Indica que el cuerpo está en formato JSON
            },
            body: bodyJson,
          )
          .timeout(const Duration(seconds: 10));
      print(
          'response devuelto: status:${response.statusCode}, data: ${jsonDecode(response.body)}');
      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      if (response.statusCode == 401) {
        resultResponse.statusCode = 401;
        resultResponse.message = "Sesión Expirada";
        resultResponse.data = null;
        LocalStorage store = await LocalStorage.initialize();
        store.deleteItems(["token", "user"]);
        if (mountedProp == true || mounted == true) {
          if (contextProp != null || context != null) {
            GoRouter.of((contextProp ?? context)!).go('/login');
            return resultResponse;
          }
        }
      } else if (response.statusCode == 500 || response.statusCode == 400) {
        resultResponse.statusCode = response.statusCode;
        resultResponse.message = parseDataResponse.message ?? '-';
      } else if (response.statusCode == 200) {
        resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
        resultResponse.message =
            parseDataResponse.data?.message ?? "Obteniendo información";
        resultResponse.data = parseDataResponse.data?.data;
      }
      resultResponse.data = null;
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      Toasted(
              toastLength: ToastLenght.lengthLong,
              message: '$urlCompleta=>${ex.toString()}',
              backgroundColor: Colors.red,
              textColor: Colors.white)
          .show();
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }
}
