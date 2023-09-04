import 'package:farmaenlaceapp/pages/farmastock/verificacion_error.dart';
import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/models/farmastock/DTOs/ArticulosDTO.dart';
import 'package:farmaenlaceapp/providers/articulos_provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/app_bar.dart';
import '../../components/barra_busqueda.dart';
import '../../components/side_menu.dart';
import 'package:provider/provider.dart';
import '../../models/farmastock/planificacion_response.dart';
import '../../widgets/farmastock/farmastock_widets.dart';

class VerificacionPlanificacionScreen extends StatefulWidget {
  final PlanInventario planificacion;
  const VerificacionPlanificacionScreen(
      {super.key, required this.planificacion});
  @override
  State<VerificacionPlanificacionScreen> createState() =>
      _VerificacionPlanificacionScreenState();
}

//TODO: NAVIGATION REPLACE
class _VerificacionPlanificacionScreenState
    extends State<VerificacionPlanificacionScreen> {
  List<ArticuloDTO> articulos = [];
  List<ArticuloDTO> articulosFiltrados = [];

  final TextEditingController _searchController = TextEditingController();
  String _busquedaCodigoProd = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Inicializa el estado
  @override
  void initState() {
    _init();
    super.initState();
  }

  //Generamos la consulta
  _init() async {
    await Provider.of<ArticulosProvider>(context, listen: false)
        .getlstArticulosDTO(widget.planificacion);
    articulos =
        Provider.of<ArticulosProvider>(context, listen: false).lstArticulosDTO;
    Provider.of<ArticulosProvider>(context, listen: false).reconteo = 2;

    /*int.tryParse(widget.planificacion.reconteo) == null
        ? 0
        : int.parse(widget.planificacion.reconteo);*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const SideMenu(),
      body: Consumer<ArticulosProvider>(
        builder: (context, articulosProvider, child) {
          if (articulosProvider.isLoading && articulos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (articulos.isEmpty) {
              return const Center(
                  child: NoInfo(
                      url:
                          'lib/assets/images/farmastock/medicamentos_verificados.png',
                      mensajeVacio: 'No hay artículos por revisar'));
            } else {
              //VALIDAMOS VARIABLES PARA FILTROS
              if (_busquedaCodigoProd.isNotEmpty) {
                // Si se ha ingresado un idPlan para buscar, filtra la lista original según ese idPlan
                articulosFiltrados = articulos
                    .where((articulo) =>
                        articulo.planArticulo.codigo
                            .toUpperCase()
                            .contains(_busquedaCodigoProd.toUpperCase()) ||
                        articulo.planArticulo.descripcion
                            .toUpperCase()
                            .contains(_busquedaCodigoProd.toUpperCase()))
                    .toList();
              } else {
                // Si no se ha ingresado un idPlan para buscar, muestra la lista original sin filtrar
                articulosFiltrados = articulos;
              }
              //DIBUJAMOS EL WIDGET
              return Column(
                children: [
                  Text(
                    "Planificación ${widget.planificacion.idPlan}"
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: size.height * 0.030,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "Tiene ${articulosProvider.reconteo} revisiones",
                    style: TextStyle(
                      fontSize: size.height * 0.020,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: BarraBusqueda(
                      onFilter: (value) {
                        setState(() {
                          _busquedaCodigoProd = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: size.height * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Pentiendes: ${articulosProvider.pendientes}"),
                        FloatingActionButton(
                          child: const Icon(Icons.save_outlined),
                          onPressed: () {
                            if (articulosProvider.validarLista()) {
                              String mensajeConfirmacion = "";
                              articulosProvider.verificarNecesidadReconteo();
                              if (articulosProvider.reconteo == 0) {
                                mensajeConfirmacion =
                                    "La revisión se ha ejecutado con éxito, aún así el estado de su planificación es:";
                                articulosProvider.revisionFinal();
                                QuickAlert.show(
                                  context: context,
                                  title: "Inventario Enviado",
                                  type: QuickAlertType.success,
                                  text: mensajeConfirmacion,
                                  confirmBtnText: 'Aceptar',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const VerificacionError()),
                                    );
                                  },
                                );
                              } else {
                                mensajeConfirmacion =
                                    "Aún tiene revisiones por favor, revise nuevamente los artículos.";
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.info,
                                  title: "!Ten Cuidado!",
                                  text: mensajeConfirmacion,
                                  confirmBtnText: 'Si',
                                  confirmBtnColor: Colors.yellow,
                                  onConfirmBtnTap: () {
                                    Navigator.pop(context, false);
                                  },
                                );
                              }
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: '¡Ha ocurrido un error!',
                                text: "Aún faltan artículos por procesar.",
                              );
                            }
                          },
                        ),
                        Text("Contados: ${articulosProvider.contados}"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      child: ListView.separated(
                        itemCount: articulosFiltrados.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: size.height * 0.02,
                          );
                        },
                        itemBuilder: (context, index) {
                          return ArticuloCardField(
                            articuloDTO: articulosFiltrados[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
