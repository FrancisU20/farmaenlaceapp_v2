class Kardex {
  late String traspaso;
  late String usuarioFarmacia;
  late String bodega;
  int caja = 0;
  int funda = 0;
  int paca = 0;
  late String fechaTraspaso;
  late List<dynamic> articulos;

  Kardex(
      {required this.traspaso,
      required this.usuarioFarmacia,
      required this.bodega,
      required this.caja,
      required this.funda,
      required this.paca,
      required this.fechaTraspaso,
      required this.articulos});
}
