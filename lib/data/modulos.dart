import 'package:farmaenlaceapp/theme/colors.dart';
import 'package:farmaenlaceapp/models/modulos.dart';

final List<Modulo> modulo = [
  Modulo(
      text: "FarmaStock",
      descripcion: "Realice planificaciones",
      imageUrl: "lib/assets/images/modulos/icon/farmastock.png",
      backImage: "lib/assets/images/modulos/box/box1.png",
      color: kDarkBlue,
      route: "/planificacion"),
  Modulo(
      text: "FarmaRecepción",
      descripcion: "Realice inventarios",
      imageUrl: "lib/assets/images/modulos/icon/farmarecepcion.png",
      backImage: "lib/assets/images/modulos/box/box2.png",
      color: kDarkBlue,
      route: "/farmarecepcion"),
];
