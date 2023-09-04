// To parse this JSON data, do
//
//     final articulosPlanificacionResponse = articulosPlanificacionResponseFromJson(jsonString);

import 'dart:convert';

class ArticulosPlanificacionResponse {
  String respuesta;
  Mensaje mensaje;

  ArticulosPlanificacionResponse({
    required this.respuesta,
    required this.mensaje,
  });

  factory ArticulosPlanificacionResponse.fromRawJson(String str) =>
      ArticulosPlanificacionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticulosPlanificacionResponse.fromJson(Map<String, dynamic> json) =>
      ArticulosPlanificacionResponse(
        respuesta: json["respuesta"],
        mensaje: Mensaje.fromJson(json["mensaje"]),
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
        "mensaje": mensaje.toJson(),
      };
}

class Mensaje {
  List<PlanArticulo> planArticulos;

  Mensaje({
    required this.planArticulos,
  });

  factory Mensaje.fromRawJson(String str) => Mensaje.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        planArticulos: List<PlanArticulo>.from(
            json["plan_articulos"].map((x) => PlanArticulo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plan_articulos":
            List<dynamic>.from(planArticulos.map((x) => x.toJson())),
      };
}

class PlanArticulo {
  String codigo;
  String descripcion;
  int valorconversion;
  int stock;
  String barra;
  List<Barra> barras;
  String pvf;

  PlanArticulo({
    required this.codigo,
    required this.descripcion,
    required this.valorconversion,
    required this.stock,
    required this.barra,
    required this.barras,
    required this.pvf,
  });

  factory PlanArticulo.fromRawJson(String str) =>
      PlanArticulo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanArticulo.fromJson(Map<String, dynamic> json) => PlanArticulo(
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        valorconversion: json["valorconversion"],
        stock: json["stock"],
        barra: json["barra"],
        barras: List<Barra>.from(json["barras"].map((x) => Barra.fromJson(x))),
        pvf: json["pvf"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": descripcion,
        "valorconversion": valorconversion,
        "stock": stock,
        "barra": barra,
        "barras": List<dynamic>.from(barras.map((x) => x.toJson())),
        "pvf": pvf,
      };
}

class Barra {
  String barra;

  Barra({
    required this.barra,
  });

  factory Barra.fromRawJson(String str) => Barra.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Barra.fromJson(Map<String, dynamic> json) => Barra(
        barra: json["barra"],
      );

  Map<String, dynamic> toJson() => {
        "barra": barra,
      };
}
