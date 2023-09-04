class Articulo {
  String codigo;
  String descripcion;
  int enteros;
  int sobrantes;
  int faltantes;
  int cantidad;
  List<dynamic> barras;

  Articulo(
      {required this.codigo,
      required this.descripcion,
      required this.enteros,
      required this.sobrantes,
      required this.faltantes,
      required this.cantidad,
      required this.barras});
}
