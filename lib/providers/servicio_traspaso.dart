import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const timeout = Duration(milliseconds: 60000);

final Map<String, String> headers = {
  'Content-Type': 'application/json; charset=UTF-8',
};

class ServicioTraspaso {
  Future<List<dynamic>> traspasosTransito() async {
    //Comentar para salir a prod
    const ip = '192.168.237.190';
    //Comentar para salir a prod
    const idBodega = '190';

    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/TraspasosFarmacia?id_bodega=$idBodega';

    try {
      final http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(timeout);
      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        if (res['respuesta'].toUpperCase() == "OK") {
          final listaig = res['mensaje']['TraspasosFarmacia'];
          // Filter traspasos with estado "ET"
          List<dynamic> filteredList =
              listaig.where((traspaso) => traspaso['estado'] == 'T').toList();
          return filteredList;
        } else {
          throw res['mensaje'];
        }
      } else {
        throw 'Error de Conexión';
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw 'La conexión se demoró mucho, intente de nuevo';
      } else {
        throw 'Error de Conexión';
      }
    }
  }

  Future<List<dynamic>> traspasosRecepcion() async {
    //Comentar para salir a prod
    const ip = '192.168.237.190';
    //Comentar para salir a prod
    const idBodega = '190';
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/TraspasosFarmacia?id_bodega=$idBodega';

    try {
      final http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(timeout);
      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        if (res['respuesta'].toUpperCase() == "OK") {
          final listaig = res['mensaje']['TraspasosFarmacia'];
          // Filter traspasos with estado "ET"
          List<dynamic> filteredList =
              listaig.where((traspaso) => traspaso['estado'] == 'ET').toList();
          return filteredList;
        } else {
          throw res['mensaje'];
        }
      } else {
        throw 'Error de Conexión';
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw 'La conexión se demoró mucho, intente de nuevo';
      } else {
        throw 'Error de Conexión';
      }
    }
  }

  Future<dynamic> detalleTraspaso(String traspaso, String bodegaOrigen) async {
    //Comentar para salir a prod
    const ip = '192.168.237.190';
    //Comentar para salir a prod
    bodegaOrigen = '001';

    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/DetalleTraspaso?traspaso=$traspaso&bodegaOrg=$bodegaOrigen';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var detalles = jsonDecode(response.body);
        if (detalles['respuesta'].toUpperCase() == "OK") {
          var listaig = detalles['mensaje'];
          return listaig;
        } else {
          throw detalles['mensaje'];
        }
      } else {
        throw 'Hubo un error al comunicarse con el servidor';
      }
    } catch (e) {
      throw 'Hubo un error al comunicarse con el servidor: $e';
    }
  }

  Future<dynamic> verificarTraspaso(String traspaso) async {
    //Comentar para salir a prod
    const ip = '192.168.237.190';
    //Comentar para salir a prod
    const idBodega = '190';
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/VerificarTraspasoKardex?id_bodega=$idBodega&traspaso=$traspaso';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        if (res['respuesta'].toUpperCase() == "OK") {
          var mensaje = res['mensaje'];
          return mensaje;
        } else {
          throw res['mensaje'];
        }
      } else {
        throw 'Hubo un error al comunicarse con el servidor';
      }
    } catch (e) {
      throw 'Hubo un error al comunicarse con el servidor$e';
    }
  }

  Future<dynamic> buscarArticulos(
      String ip, String idBodega, String codigo) async {
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/BusquedaArticulo?id_bodega=$idBodega&codigo=$codigo';

    try {
      final http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(timeout);
      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        if (res['respuesta'].toUpperCase() == "OK") {
          var listaig = res['mensaje'];
          return listaig;
        } else {
          throw res['mensaje'];
        }
      } else {
        throw 'Error de Conexión';
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw 'La conexión se demoró mucho, intente de nuevo';
      } else {
        throw 'Error de Conexión';
      }
    }
  }

  Future<dynamic> generarkardex(dynamic detallejson) async {
    //Comentar para salir a prod
    const ip = '192.168.237.190';

    String detjson = jsonEncode(detallejson);
    String url = 'http://$ip/ws_plataformamovil/Service1.svc/GenerarKardex';

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: detjson,
      );

      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        return res;
      } else {
        throw 'Error de conexión';
      }
    } catch (e) {
      throw 'Error de conexión: $e';
    }
  }

  Future<dynamic> obtenerImagen(String ip, String codigo) async {
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/imagenarticulo?codigo=$codigo';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        var listaimagen = res['mensaje'];
        return listaimagen;
      } else {
        throw 'Hubo un error al comunicarse con el servidor';
      }
    } catch (e) {
      throw 'Hubo un error al comunicarse con el servidor';
    }
  }

  Future<dynamic> traspasoTemporal(
      String ip, dynamic detallejsontemporal) async {
    String detjsontmp = jsonEncode(detallejsontemporal);
    String url = 'http://$ip/ws_plataformamovil/Service1.svc/GuardarTemporal';

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: detjsontmp,
      );

      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        return res;
      } else {
        throw 'Error de conexión';
      }
    } catch (e) {
      throw 'Error de conexión';
    }
  }

  Future<dynamic> recuperarTemporal(String ip, String traspaso) async {
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/RecuperarTemporal?identificador=$traspaso';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var verificar = jsonDecode(response.body);
        return verificar;
      } else {
        throw 'Hubo un error al comunicarse con el servidor';
      }
    } catch (e) {
      throw 'Hubo un error al comunicarse con el servidor';
    }
  }

  Future<dynamic> eliminarTemporal(String ip, String traspaso) async {
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/EliminarTemporal?identificador=$traspaso';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var eliminar = jsonDecode(response.body)['mensaje'];
        return eliminar;
      } else {
        throw 'Hubo un error al comunicarse con el servidor';
      }
    } catch (e) {
      throw 'Hubo un error al comunicarse con el servidor';
    }
  }

  Future<dynamic> verificarCaja(String ip, String bodega) async {
    //Comentar para salir a prod
    ip = '192.168.237.190';
    //Comentar para salir a prod
    bodega = '190';
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/VerificacionCajas?bodega=$bodega';

    try {
      final http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(timeout);
      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        if (res['respuesta'].toUpperCase() == "OK") {
          var listaig = res['mensaje']['TraspasosModel'];
          return listaig;
        } else {
          throw res['mensaje'];
        }
      } else {
        throw 'Error de Conexión';
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw 'La conexión se demoró mucho, intente de nuevo';
      } else {
        throw 'Error de Conexión';
      }
    }
  }

  Future<dynamic> guardarPendiente(
      String ip, dynamic detallejsontemporal) async {
    String detjsontmp = jsonEncode(detallejsontemporal);
    String url =
        'http://$ip/ws_plataformamovil/Service1.svc/GuardarPendientesVerificacion';

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: detjsontmp,
      );

      if (response.statusCode == 200) {
        String stringResponse = const Utf8Decoder().convert(response.bodyBytes);
        final res = jsonDecode(stringResponse);
        return res;
      } else {
        throw 'Error de conexión';
      }
    } catch (e) {
      throw 'Error de conexión';
    }
  }
}
