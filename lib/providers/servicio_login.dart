import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, String> headers = {
  'Content-Type': 'application/json; charset=UTF-8',
};

class ServicioLogin {
  final String controlVersion = dotenv.env['control_version'].toString();
  final TextEditingController ipFarmaciaController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  void dispose() {
    ipFarmaciaController.dispose();
    usuarioController.dispose();
    contrasenaController.dispose();
  }

  //Guarda datos en el dispositivo del usuario
  Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw ArgumentError('Tipo de dato no compatible');
    }
  }

  //Elimina datos en el dispositivo del usuario
  Future<void> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  //Obtiene datos del dispositivo del usuario por su key
  Future<dynamic> retrieveData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key);

    return value;
  }

  //Obtiene

  //Obtiene la ip del dispositivo
  Future<String> getIPAddress() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.ipify.org/?format=json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final ipAddress = data['ip'];
        return ipAddress;
      } else {
        throw Exception('No se pudo obtener la ip del dispositivo');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Función del login que se conecta al servicio
  Future<String> loginUser() async {
    String ip = ipFarmaciaController.text;
    String usuario = usuarioController.text + controlVersion;
    String clave = contrasenaController.text;
    final ipmovil = await getIPAddress();
    final url =
        'http://$ip/ws_plataformamovil/Service1.svc/AutentificarUsuario?usuario=$usuario&contrasenia=$clave&ipmovil=$ip&ipMovil2=$ipmovil';
    const fetchTimeout = Duration(milliseconds: 60000);
    final timeout = Timer(fetchTimeout, () {
      throw TimeoutException(
          'La conexión se demoró mucho, revise los parámetros de conexión e intente de nuevo');
    });

    try {
      final http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(fetchTimeout);
      timeout.cancel();

      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);

        if (res['respuesta'].toUpperCase() == 'OK') {
          await saveData('ip', ip);
          await saveData('ipMovil', ipmovil);
          await saveData('nombre', res['mensaje']['nombre']);
          await saveData('usuario', usuario.split('_')[0]);
          await saveData('cedula', res['mensaje']['cedula']);
          await saveData('centro_costo', res['mensaje']['centro_costo']);
          await saveData('NombreCorto', res['mensaje']['NombreCorto']);
          await saveData('farmacia', res['mensaje']['farmacia']);
          await saveData('idbodega', res['mensaje']['idbodega']);
          await saveData('isLoggedIn', true);
          return 'OK';
        } else {
          return res['mensaje'];
        }
      } else if (response.statusCode == 500) {
        return 'La aplicación no pudo conectarse al servidor.';
      } else if (response.statusCode == 400) {
        return 'Por favor active los permisos de escritura en el eventLog de la farmacia.${response.statusCode}';
      } else if (response.statusCode == 409) {
        return 'Error 409';
      } else if (response.statusCode == 406) {
        return 'Error 406';
      } else {
        return 'No fue posible conectarse';
      }
    } catch (err) {
      if (err is TimeoutException) {
        return 'La conexión se demoró mucho, revise los parámetros de conexión e intente de nuevo';
      } else {
        return err.toString();
      }
    }
  }

  //Funcion que recupera los datos de local Storage
  Future<List<dynamic>> datosUsuario() async {
    String? ip = await retrieveData('ip');
    String? nombre = await retrieveData('nombre');
    String? usuario = await retrieveData('usuario');
    String? cedula = await retrieveData('cedula');
    String? centroCosto = await retrieveData('centro_costo');
    String? nombreCorto = await retrieveData('NombreCorto');
    String? farmacia = await retrieveData('farmacia');
    String? idBodega = await retrieveData('idbodega');
    bool? isLoggedIn = await retrieveData('isLoggedIn');

    List<dynamic> datosUsuario = [
      ip,
      nombre,
      usuario,
      cedula,
      centroCosto,
      nombreCorto,
      farmacia,
      idBodega,
      isLoggedIn
    ];

    return datosUsuario;
  }

  //Funcion elimina datos del usuario de la memoria del dispositivo
  Future<String> logoutUser() async {
    await deleteData('ip');
    await deleteData('nombre');
    await deleteData('usuario');
    await deleteData('cedula');
    await deleteData('centro_costo');
    await deleteData('NombreCorto');
    await deleteData('farmacia');
    await deleteData('idbodega');
    await deleteData('isLoggedIn');
    await deleteData('atribuciones');
    return 'OK';
  }
}
