import 'package:farmaenlaceapp/pages/farmastock/verificacion_planificacion_screen.dart';
import 'package:farmaenlaceapp/providers/servicio_farmastock.dart';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/app_bar.dart';
import '../../components/barra_busqueda.dart';
import '../../components/side_menu.dart';
import 'package:provider/provider.dart';
import '../../models/farmastock/planificacion_response.dart';
import '../../widgets/farmastock/farmastock_widets.dart';

class PlanificacionesScreen extends StatefulWidget {
  const PlanificacionesScreen({super.key});

  @override
  State<PlanificacionesScreen> createState() => _PlanificacionesScreenState();
}

class _PlanificacionesScreenState extends State<PlanificacionesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchedIdPlan = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final farmaStockProvider =
        Provider.of<ServicioFarmastock>(context, listen: false);
    List<PlanInventario> planificaciones = [];
    List<PlanInventario> planificacionesFiltradas = [];
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const SideMenu(),
      body: Column(
        children: [
          Container(
            child: Text(
              "Planificaciones".toUpperCase(),
              style: TextStyle(
                fontSize: size.height * 0.030,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: BarraBusqueda(
              onFilter: (value) {
                setState(() {
                  _searchedIdPlan = value;
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: farmaStockProvider.getPalnificacionByIP(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length != 0) {
                      planificaciones = snapshot.data;
                      if (_searchedIdPlan.isNotEmpty) {
                        // Si se ha ingresado un idPlan para buscar, filtra la lista original según ese idPlan
                        planificacionesFiltradas = planificaciones
                            .where((planificacion) => planificacion.idPlan
                                .toString()
                                .contains(_searchedIdPlan))
                            .toList();
                      } else {
                        // Si no se ha ingresado un idPlan para buscar, muestra la lista original sin filtrar
                        planificacionesFiltradas = planificaciones;
                      }

                      return Column(
                        children: [
                          _PlanificacionesPendientes(
                              planificacionesPendientes:
                                  planificacionesFiltradas.length),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: size.height * 0.02),
                            child: ListView.separated(
                              itemCount: planificacionesFiltradas.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: size.height * 0.02,
                                );
                              },
                              itemBuilder: (context, index) {
                                return PlanificacionCard(
                                  idPlan:
                                      planificacionesFiltradas[index].idPlan,
                                  descripcion:
                                      planificacionesFiltradas[index].nombre,
                                  numConteos:
                                      planificacionesFiltradas[index].reconteo,
                                  press: () {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.info,
                                      title: "!Ten Cuidado!",
                                      text:
                                          '¿Está seguro que desea bloquear los productos?',
                                      confirmBtnText: 'Si',
                                      cancelBtnText: 'No',
                                      confirmBtnColor: Colors.yellow,
                                      onConfirmBtnTap: () async {
                                        //VERIFICAMOS SI HACE EL BLOQUEO
                                        String validadorBloqueo = "ok";

                                        /* await farmaStockProvider
                                                .getBloquearArticulos(
                                                    planificacionesFiltradas[
                                                            index]
                                                        .idPlan,
                                                    planificacionesFiltradas[
                                                            index]
                                                        .origen);*/
                                        if (validadorBloqueo.toUpperCase() ==
                                            "OK") {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VerificacionPlanificacionScreen(
                                                planificacion:
                                                    planificacionesFiltradas[
                                                        index],
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.pop(context, false);
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            title: '¡Ha ocurrido un error!',
                                            text: validadorBloqueo,
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: NoInfo(
                              url:
                                  'lib/assets/images/farmastock/sin_planificaciones.png',
                              mensajeVacio:
                                  'No hay planificaciones por revisar'));
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Tarjeta que inidica las planificaciones pendientes
class _PlanificacionesPendientes extends StatelessWidget {
  final int planificacionesPendientes;
  const _PlanificacionesPendientes({
    super.key,
    required this.planificacionesPendientes,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.024),
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.blue.shade900),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Planificaciones pendientes: $planificacionesPendientes",
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }
}
