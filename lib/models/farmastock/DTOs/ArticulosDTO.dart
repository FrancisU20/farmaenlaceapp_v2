import 'package:flutter/material.dart';

import '../articulos_planificacion_response.dart';

class ArticuloDTO {
  PlanArticulo planArticulo;
  ImageProvider imagenArticulo;
  int stockCaja;
  int stockFraccion;
  bool validado;

  ArticuloDTO(
      {required this.planArticulo,
      required this.imagenArticulo,
      required this.stockCaja,
      required this.stockFraccion,
      required this.validado});

  Map<String, dynamic> toJson() {
    return {
      'PlanArticulo': planArticulo.toJson(),
      'stockCaja': stockCaja,
      'stockFraccion': stockFraccion,
      'validado': validado,
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'articulo': planArticulo.toJson(),
    };
  }
}
