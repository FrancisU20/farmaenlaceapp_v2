import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/pages/home/login_page.dart';
import 'package:farmaenlaceapp/pages/home/home_page.dart';
import 'package:farmaenlaceapp/pages/home/profile_page.dart';
import 'package:farmaenlaceapp/pages/traspasos/traspasos_recepcion.dart';
import 'package:farmaenlaceapp/pages/traspasos/traspasos_transito.dart';
import 'package:farmaenlaceapp/pages/traspasos/traspasos_detalle.dart';
import 'package:farmaenlaceapp/pages/home/modules/farmastock_dashboard.dart';
import 'package:farmaenlaceapp/pages/home/modules/farmarecepcion_dashboard.dart';

import 'package:farmaenlaceapp/pages/farmastock/planificaciones_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const LoginPage(),
  '/home': (context) => const HomePage(),
  '/farmastock': (context) => const FarmastockDashboard(),
  '/farmarecepcion': (context) => const FarmarecepcionDashboard(),
  '/perfil': (context) => const ProfilePage(),
  '/traspasos': (context) => const TraspasosTransito(),
  '/planificacion': (context) => const PlanificacionesScreen(),
  '/traspasos-verificados': (context) => const TraspasosRecepcion(),
  '/traspasos-detalle': (context) => const TraspasoDetalle(),
};
