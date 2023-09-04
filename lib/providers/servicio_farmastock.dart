import 'dart:async';
import 'package:farmaenlaceapp/models/farmastock/DTOs/ArticulosDTO.dart';
import 'package:farmaenlaceapp/models/farmastock/articulos_planificacion_response.dart';
import 'package:farmaenlaceapp/models/farmastock/imagen_response.dart';
import 'package:farmaenlaceapp/models/farmastock/planificacion_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const timeout = Duration(milliseconds: 60000);

class ServicioFarmastock with ChangeNotifier {
  /* -------------------------------------- Get ----------------------------- */
  Future<List<PlanInventario>> getPalnificacionByIP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ip = prefs.getString('ip');
      const ipPrueba = '192.168.237.190';

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      String urlGet =
          'http://$ipPrueba/ws_plataformamovil/Service1.svc/ListadoPlanificaciones';

      final http.Response response = await http.get(
        Uri.parse(urlGet),
        headers: headers,
      );

      String stringResponse =
          const Utf8Decoder().convert(response.body.codeUnits);
      final parsedJson = jsonDecode(stringResponse);

      if (parsedJson['respuesta'].toUpperCase() == "OK") {
        final planificacionData = PlanificacionResponse.fromJson(parsedJson);
        return planificacionData.mensaje.planInventario;
      } else {
        print("TIENE QUE MOSTRAR UNA IMAGEN");
        List<PlanInventario> vacio = [];
        return vacio;
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw 'La conexión se demoró mucho, intente de nuevo';
      } else {
        throw 'Error de Conexión';
      }
    }
  }

  Future<String> getBloquearArticulos(int idPlan, String origen) async {
    try {
      //TODO: VALIRDAR QUE EL LOGIN ESTÉ GUARDANDO LA INFORMACIÓN DE MANERA CORRECTA
      final prefs = await SharedPreferences.getInstance();
      final String ip = prefs.getString('ip')!;
      //final String usuario = prefs.getString('usuario');
      //final String ipMovil = prefs.getString('ipMovil');
      const String ipPrueba = '192.168.237.190';
      final String usuario = "jhostyn_benalcazar";
      final String ipMovil = "localhost:pruebas";

      String urlGet =
          'http://$ipPrueba/ws_plataformamovil/Service1.svc/RestringirArticulosContar?id_plan=$idPlan&origen=$origen&usuario=$usuario&ip=$ipMovil';

      final http.Response response = await http.get(Uri.parse(urlGet));
      final parsedJson = jsonDecode(response.body);

      print(parsedJson['mensaje']);
      if (parsedJson['respuesta'].toUpperCase() == "OK") {
        if (await getCambiarEstadoImpreso(idPlan, origen)) {
          return "OK";
        } else {
          return "NO SE HA LOGRADO CAMBIAR DE ESTADO A IMPRESO";
        }
      } else {
        return "HA OCURRIDO UN ERROR AL MOMENTO DE CONECTARSE AL SERVIDOR";
      }
    } catch (e) {
      if (e is TimeoutException) {
        return 'La conexión se demoró mucho, intente de nuevo';
      } else {
        return 'Error de Conexión';
      }
    }
  }

  Future<bool> getCambiarEstadoImpreso(int idPlan, String origen) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String ip = prefs.getString('ip')!;
      //inal String usuario = prefs.getString('usuario');
      //final String ipMovil = prefs.getString('ipMovil');
      const String ipPrueba = '192.168.237.190';
      final String usuario = "jhostyn_benalcazar";
      final String ipMovil = "localhost:pruebas";

      String urlGet =
          'http://$ipPrueba/ws_plataformamovil/Service1.svc/ActualizarPlanificacionaContar?id_plan= $idPlan&origen=$origen';
      final http.Response response = await http.get(Uri.parse(urlGet));
      final parsedJson = jsonDecode(response.body);
      print(parsedJson['mensaje']);

      if (parsedJson['respuesta'].toUpperCase() == "OK") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw 'La conexión se demoró mucho, intente de nuevo';
      } else {
        throw 'Error de Conexión';
      }
    }
  }
}
