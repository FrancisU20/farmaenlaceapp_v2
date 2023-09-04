import 'package:farmaenlaceapp/interfaces/kardex.dart';

class KardexModel implements Kardex {
  @override
  String traspaso;

  @override
  String usuarioFarmacia;

  @override
  String bodega;

  @override
  int caja;

  @override
  int funda;

  @override
  int paca;

  @override
  String fechaTraspaso;

  @override
  List<dynamic> articulos;

  KardexModel({
    required this.traspaso,
    required this.usuarioFarmacia,
    required this.bodega,
    required this.caja,
    required this.funda,
    required this.paca,
    required this.fechaTraspaso,
    required this.articulos,
  });

  Map<String, dynamic> toJson() {
    return {
      'traspaso': traspaso,
      'usuarioFarmacia': usuarioFarmacia,
      'bodega': bodega,
      'caja': caja,
      'funda': funda,
      'paca': paca,
      'fechaTraspaso': fechaTraspaso,
      'articulos': articulos,
    };
  }
}
