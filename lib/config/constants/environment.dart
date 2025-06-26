import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: ".env");

    late String apiBaseUrl = dotenv.get('API_URL');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //pasamos la base url en el shared preference para usarlo en el package http2
    await prefs.setString('api_baseURL', apiBaseUrl);
    print(apiBaseUrl);
  }

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'No esta configurado el API_URL';
}
