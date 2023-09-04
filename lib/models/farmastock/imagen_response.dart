// To parse this JSON data, do
//
//     final imagenResponse = imagenResponseFromJson(jsonString);

import 'dart:convert';

class ImagenResponse {
  String respuesta;
  Mensaje mensaje;

  ImagenResponse({
    required this.respuesta,
    required this.mensaje,
  });

  factory ImagenResponse.fromRawJson(String str) =>
      ImagenResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImagenResponse.fromJson(Map<String, dynamic> json) => ImagenResponse(
        respuesta: json["respuesta"],
        mensaje: Mensaje.fromJson(json["mensaje"]),
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
        "mensaje": mensaje.toJson(),
      };
}

class Mensaje {
  String codigo;
  String base64;

  Mensaje({
    required this.codigo,
    required this.base64,
  });

  factory Mensaje.fromRawJson(String str) => Mensaje.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        codigo: json["codigo"],
        base64: json["base64"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "base64": base64,
      };
}
