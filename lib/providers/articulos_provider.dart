import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmaenlaceapp/models/farmastock/DTOs/ArticulosDTO.dart';
import 'package:farmaenlaceapp/models/farmastock/articulos_planificacion_response.dart';
import 'package:farmaenlaceapp/models/farmastock/imagen_response.dart';

import '../models/farmastock/planificacion_response.dart';

const timeout = Duration(milliseconds: 60000);

class ArticulosProvider with ChangeNotifier {
  //TODO: CAMBIAR NOMBRE A PROVIDER

  List<ArticuloDTO> _lstArticulosDTO = [];

  bool isLoading = false;

  int pendientes = 0;
  int contados = 0;

  int reconteo = 0;

  double descuento = 0;
  double aumento = 0;
  double total = 0;

  late PlanInventario planificacion;

  List<ArticuloDTO> get lstArticulosDTO {
    return [..._lstArticulosDTO];
  }

  set lstArticulosDTO(List<ArticuloDTO> lstArticulosDTO) {
    _lstArticulosDTO = lstArticulosDTO;
  }

  Future<void> getlstArticulosDTO(
      PlanInventario planificacionSeleccionada) async {
    isLoading = true;
    _lstArticulosDTO = await getArticulosByIpIdplanOrigen(
        planificacionSeleccionada.idPlan, planificacionSeleccionada.origen);
    planificacion = planificacionSeleccionada;
    if (planificacion.estado == "CREADO") {
      planificacion.estado = "IMPRESO";
    }

    print("LISTA ARTICULOS: ${_lstArticulosDTO.length}");
    contados = 0;
    pendientes = _lstArticulosDTO.length;
    isLoading = false;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------------- */
  /* -------------------------------------- SERVICIOS ----------------------------- */
  /* -------------------------------------------------------------------------------- */
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  /* -------------------------------------------------------------------------------- */
  /* -------------------------------------- GET ----------------------------------- */
  /* -------------------------------------------------------------------------------- */

  Future<List<ArticuloDTO>> getArticulosByIpIdplanOrigen(
      int idPlan, String origen) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ip = prefs.getString('ip');
      const ipPrueba = '192.168.237.190';

      print("$idPlan - $origen");
      //Ejecución de la consulta

      String urlGet =
          'http://$ipPrueba/ws_plataformamovil/Service1.svc/ListadoArticulosPlanificacion?id_plan=$idPlan&origen=$origen';

      final http.Response response = await http.get(
        Uri.parse(urlGet),
        headers: headers,
      );

      //Interpretación de resultados
      String stringResponse =
          const Utf8Decoder().convert(response.body.codeUnits);
      final parsedJson = jsonDecode(stringResponse);

      if (parsedJson['respuesta'].toUpperCase() == "OK") {
        //Lista ArticuloDTO
        List<ArticuloDTO> listaArticulosDTO = [];
        //Asignamos a la lista de artículos
        final planificacionData =
            ArticulosPlanificacionResponse.fromJson(parsedJson);
        List<PlanArticulo> listaArticulos =
            planificacionData.mensaje.planArticulos;

        for (PlanArticulo articulo in listaArticulos) {
          String urlGetImage =
              'http://$ipPrueba/ws_plataformamovil/Service1.svc/imagenarticulo?codigo=${articulo.codigo}';

          final http.Response responseImage = await http.get(
            Uri.parse(urlGetImage),
          );

          final jsonData = responseImage.body;
          final parsedJson = json.decode(jsonData);
          final imagenData = ImagenResponse.fromJson(parsedJson);

          ArticuloDTO articuloDtoADD = ArticuloDTO(
              imagenArticulo:
                  MemoryImage(base64Decode(imagenData.mensaje.base64)),
              stockCaja: 0,
              stockFraccion: 0,
              planArticulo: articulo,
              validado: false);

          listaArticulosDTO.add(articuloDtoADD);
        }
        return listaArticulosDTO;
      } else {
        print("TIENE QUE MOSTRAR UNA IMAGEN");
        List<ArticuloDTO> vacio = [];
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

  /* -------------------------------------------------------------------------------- */
  /* -------------------------------------- POST ----------------------------------- */
  /* ------------------------------------------------------------------------------- */
  Future<void> postGuardarTemporal() async {
    const ipPrueba = '192.168.237.190';
    String urlPost =
        'http://$ipPrueba/ws_plataformamovil/Service1.svc/GuardarTemporal';

    //Variables a asignar
    final prefs = await SharedPreferences.getInstance();
    String usuario = prefs.getString('usuario')!;
    String identificador = "${planificacion.idPlan}${planificacion.estado}";
    DateTime fechaActual = new DateTime.now();
    String fechaActualToString = fechaActual.toIso8601String();
    List<Map<String, dynamic>> articuloDTO_JSON =
        _lstArticulosDTO.map((articuloDTO) => articuloDTO.toJson2()).toList();

    Map<String, dynamic> datatmp = {
      'articulos': articuloDTO_JSON[0],
      'articulostmp': articuloDTO_JSON,
      'pagina': 'articulos'
    };

    PlanInventario data2 = planificacion;
    //Ejecución del servicio
    final http.Response response = await http.post(
      Uri.parse(urlPost),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'usuario': usuario,
        'identificador': identificador,
        'fecha': fechaActualToString,
        'data': datatmp,
        'data2': data2.toJson(),
      }),
    );
    final jsonData = response.body;
    final parsedJson = json.decode(jsonData);
    if (response.statusCode == 201) {
      print(response.body);
    } else if (response.statusCode == 400) {
      final errorMessage = json.decode(jsonData)['message'];
      throw errorMessage;
    } else {
      throw Exception(
          'Unexpected error occurred'); // Throw a generic exception for other status codes
    }
  }

  /* -------------------------------------------------------------------------------- */
  /* -------------------------------------- UTILITARIOS ----------------------------- */
  /* -------------------------------------------------------------------------------- */
  bool validarLista() {
    bool respuesta = true;
    for (var aritculoDTO in _lstArticulosDTO) {
      if (!aritculoDTO.validado) {
        respuesta = false;
      }
    }
    return respuesta;
  }

  guardarArticulo() {
    //articuloGuardar.validado = true;
    pendientes--;
    contados++;
    notifyListeners();
  }

  bool exiteArticulo(String codigoBarras) {
    for (var aritculoDTO in _lstArticulosDTO) {
      if (aritculoDTO.planArticulo.barra == codigoBarras) {
        return true;
      }
    }
    return false;
  }

  verificarNecesidadReconteo() {
    if (reconteo > 0) {
      bool necistaReconteo = true;
      lstArticulosDTO.forEach((articuloPublico) {
        //Artículo accedido modificado desde los widgets, este modifica a la lista privada, es una copia de ella.
        int stockValidado = (articuloPublico.stockCaja *
                articuloPublico.planArticulo.valorconversion) +
            articuloPublico.stockFraccion;
        if (articuloPublico.planArticulo.stock == stockValidado) {
          reconteo = 0;
          necistaReconteo = false;
        } else {
          contados--;
          pendientes++;
          articuloPublico.validado = false;
        }
      });

      if (necistaReconteo) {
        reconteo--;
      }

      notifyListeners();
    }
    postGuardarTemporal();
  }

  void revisionFinal() {
    aumento = 0;
    descuento = 0;
    total = 0;
    lstArticulosDTO.forEach((articuloProcesado) {
      //Pasamo la cantidad de STOCK a CAJAS y FRACCIONES
      int cajasReal = articuloProcesado.planArticulo.stock ~/
          articuloProcesado.planArticulo.valorconversion;
      int fraccionesReal = articuloProcesado.planArticulo.stock %
          articuloProcesado.planArticulo.valorconversion;

      //Verificamos con la info recolectada
      articuloProcesado.stockCaja = articuloProcesado.stockCaja - cajasReal;
      articuloProcesado.stockFraccion =
          articuloProcesado.stockFraccion - fraccionesReal;

      // Revisamos si las fracciones obtenidas pueden convertirse en caja
      if (articuloProcesado.stockFraccion >=
          articuloProcesado.planArticulo.valorconversion) {
        articuloProcesado.stockCaja = articuloProcesado.stockCaja +
            (articuloProcesado.stockFraccion ~/
                articuloProcesado.planArticulo.valorconversion);
        articuloProcesado.stockFraccion = articuloProcesado.stockFraccion %
            articuloProcesado.planArticulo.valorconversion;
      }

      // Si no hay incovenientes quitamos los artículos buenos
      if (articuloProcesado.stockCaja == 0 &&
          articuloProcesado.stockFraccion == 0) {
        //TODO: VERIFICAR SI ES CON TODOS O SOLO CON ALGUNOS
        //_lstArticulosDTO.remove(articuloProcesado);
      } else {
        //Calculamos descuentos, aumentos y total
        //FRACCIONES
        if (articuloProcesado.stockFraccion < 0) {
          descuento = descuento +
              (articuloProcesado.stockFraccion *
                  double.parse(articuloProcesado.planArticulo.pvf));
        } else {
          aumento = aumento +
              (articuloProcesado.stockFraccion *
                  double.parse(articuloProcesado.planArticulo.pvf));
        }
        if (articuloProcesado.stockCaja < 0) {
          descuento = descuento +
              ((articuloProcesado.stockCaja *
                      articuloProcesado.planArticulo.valorconversion) *
                  double.parse(articuloProcesado.planArticulo.pvf));
        } else {
          aumento = aumento +
              ((articuloProcesado.stockCaja *
                      articuloProcesado.planArticulo.valorconversion) *
                  double.parse(articuloProcesado.planArticulo.pvf));
        }
        total = descuento + aumento;
      }
    });
  }
}
