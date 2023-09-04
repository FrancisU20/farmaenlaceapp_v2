import 'dart:convert';

class PlanificacionResponse {
  String respuesta;
  Mensaje mensaje;

  PlanificacionResponse({
    required this.respuesta,
    required this.mensaje,
  });

  factory PlanificacionResponse.fromRawJson(String str) =>
      PlanificacionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanificacionResponse.fromJson(Map<String, dynamic> json) =>
      PlanificacionResponse(
        respuesta: json["respuesta"],
        mensaje: Mensaje.fromJson(json["mensaje"]),
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
        "mensaje": mensaje.toJson(),
      };
}

class Mensaje {
  List<PlanInventario> planInventario;

  Mensaje({
    required this.planInventario,
  });

  factory Mensaje.fromRawJson(String str) => Mensaje.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        planInventario: List<PlanInventario>.from(
            json["plan_inventario"].map((x) => PlanInventario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plan_inventario":
            List<dynamic>.from(planInventario.map((x) => x.toJson())),
      };
}

class PlanInventario {
  int idPlan;
  String nombre;
  String origen;
  String reconteo;
  String estado;
  String fecha;

  PlanInventario({
    required this.idPlan,
    required this.nombre,
    required this.origen,
    required this.reconteo,
    required this.estado,
    required this.fecha,
  });

  factory PlanInventario.fromRawJson(String str) =>
      PlanInventario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanInventario.fromJson(Map<String, dynamic> json) => PlanInventario(
        idPlan: json["id_plan"],
        nombre: json["nombre"],
        origen: json["origen"],
        reconteo:json["reconteo"],
        estado: json["estado"],
        fecha: json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "id_plan": idPlan,
        "nombre": nombre,
        "origen": origen,
        "reconteo": reconteo,
        "estado": estado,
        "fecha": fecha,
      };
}
