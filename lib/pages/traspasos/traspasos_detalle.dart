// ignore_for_file: unnecessary_null_comparison
import 'package:farmaenlaceapp/models/kardex.dart';
import 'package:farmaenlaceapp/providers/servicio_traspaso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

//Importar los componentes
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:farmaenlaceapp/components/barra_busqueda.dart';

//Importar interfaces
import 'package:farmaenlaceapp/interfaces/articulo.dart';

final ServicioTraspaso servicioTraspaso = ServicioTraspaso();

class TraspasoDetalle extends StatefulWidget {
  const TraspasoDetalle({Key? key}) : super(key: key);

  @override
  TraspasoDetalleState createState() => TraspasoDetalleState();
}

class TraspasoDetalleState extends State<TraspasoDetalle> {
  late String searchText;
  late List<dynamic> listaArticulos;
  late List<Articulo> listaTemporal;
  late List<Articulo> listaFiltrada;
  bool _dataInitialized = false;

  late String? traspaso;
  late String? bodega;

  @override
  void initState() {
    super.initState();
    searchText = '';
    listaFiltrada = [];
    listaArticulos = [];
    listaTemporal = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataInitialized) {
      final Map<String, dynamic> argumentos =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      traspaso = argumentos['traspaso'];
      bodega = argumentos['bodega_org'];
      initData();
      _dataInitialized = true;
    }
  }

  Future<void> initData() async {
    try {
      final detalleTraspaso =
          await servicioTraspaso.detalleTraspaso(traspaso!, bodega!);
      listaArticulos = detalleTraspaso['articulos'];
      temporalList();
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('$error'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo de alerta
                Navigator.pushNamed(
                    context, '/home'); // Volver a la ruta "/traspasos"
              },
            ),
          ],
        ),
      );
    }
  }

  void temporalList() {
    listaTemporal = listaArticulos.map((articulo) {
      String codigo = articulo['codigo'];
      String descripcion = articulo['descripcion'];
      int enteros = 0;
      int sobrantes = 0;
      int faltantes = articulo['cantidad'];
      int cantidad = articulo['cantidad'];
      List<dynamic> barras = articulo['barras'];
      return Articulo(
        codigo: codigo,
        descripcion: descripcion,
        enteros: enteros,
        sobrantes: sobrantes,
        faltantes: faltantes,
        cantidad: cantidad,
        barras: barras,
      );
    }).toList();
    if (mounted) {
      setState(() {
        listaFiltrada = listaTemporal;
      });
    }
  }

  void filterList(String query) {
    setState(() {
      searchText = query;
      String codigo = '';
      listaFiltrada = listaTemporal.where((item) {
        List<dynamic> arrayBarras = item.barras;
        //Recorrer arrelgo array_barras
        for (var i = 0; i < arrayBarras.length; i++) {
          if (arrayBarras[i]['codigo']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            codigo = arrayBarras[i].toString();
          }
        }
        final String descripcion = item.descripcion.toString();
        return codigo.toLowerCase().contains(query.toLowerCase()) ||
            descripcion.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (listaFiltrada.isEmpty && query.isNotEmpty) {
        listaFiltrada = [];
      }
    });
  }

  //Codigo de Suma y Resta
  void sumarCantidad(Articulo articulo) {
    int index = listaFiltrada
        .indexWhere((element) => element.barras == articulo.barras);
    Articulo articuloExistente = listaFiltrada[index];

    if (articuloExistente.enteros < articuloExistente.cantidad) {
      articuloExistente.enteros = articulo.enteros + 1;
      articuloExistente.faltantes = articulo.faltantes - 1;
    } else {
      articuloExistente.sobrantes = articulo.sobrantes + 1;
    }
    // Actualizar la tabla
    setState(() {
      listaFiltrada[index] = articuloExistente;
    });
  }

  void restarCantidad(Articulo articulo) {
    int index = listaFiltrada
        .indexWhere((element) => element.barras == articulo.barras);
    Articulo articuloExistente = listaFiltrada[index];

    if (articuloExistente.sobrantes > 0) {
      articuloExistente.sobrantes = articulo.sobrantes - 1;
    } else {
      if (articuloExistente.enteros > 0) {
        articuloExistente.enteros = articulo.enteros - 1;
        articuloExistente.faltantes = articulo.faltantes + 1;
      }
    }
    // Actualizar la tabla
    setState(() {});
  }

  //Llamado de botones
  void handleSuma(String codigo) {
    try {
      Articulo item = listaFiltrada.firstWhere(
        (element) => element.barras.any((barra) => barra['codigo'] == codigo),
      );
      sumarCantidad(item);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Atención:'),
          content: Text('No se ha encontrado el artículo $codigo'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context); // Volver a la ruta "/traspasos"
              },
            ),
          ],
        ),
      );
    }
  }

  void handleResta(String codigo) {
    try {
      Articulo item = listaFiltrada.firstWhere(
        (element) => element.barras.any((barra) => barra['codigo'] == codigo),
      );
      restarCantidad(item);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Atención:'),
          content: Text('No se ha encontrado el artículo $codigo'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context); // Volver a la ruta "/traspasos"
              },
            ),
          ],
        ),
      );
    }
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Desea salir?'),
          content: const Text(
              'Se perderán los cambios realizados en el traspaso actual.'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog and prevent exit
              },
            ),
            TextButton(
              child: const Text('Salir'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and allow exit
              },
            ),
          ],
        );
      },
    ).then<bool>((value) =>
        value ??
        false); // Convert the returned Object? to bool and handle null case
  }

  void generarKardex() async {
    final datosTraspaso = await servicioTraspaso.detalleTraspaso(
        traspaso.toString(), bodega.toString());

    // Crear la lista de artículos en formato JSON de los articulos
    List<Map<String, dynamic>> articulos = listaTemporal.map((articulo) {
      return {
        'codigo': articulo.codigo,
        'descripcion': articulo.descripcion,
        'entero': articulo.enteros,
        'fraccion': 0,
        'mas': articulo.sobrantes,
        'menos': articulo.faltantes,
        'cantidad': articulo.cantidad,
        'pvf': 0
      };
    }).toList();

    KardexModel kardex = KardexModel(
      traspaso: datosTraspaso['traspaso'],
      usuarioFarmacia: datosTraspaso['usuarioFarmacia'],
      bodega: datosTraspaso['bodega'],
      caja: datosTraspaso['caja'],
      funda: datosTraspaso['funda'],
      paca: datosTraspaso['paca'],
      fechaTraspaso: datosTraspaso['fechaTraspaso'],
      articulos: articulos,
    );

// Convertir el objeto `kardex` a JSON
    Map<String, dynamic> jsonKardex = kardex.toJson();

    // Enviar los datos al controlador
    Map<String, dynamic> respuesta =
        await servicioTraspaso.generarkardex(jsonKardex);

    if (respuesta['respuesta'] == 'OK') {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Kardex generado exitosamente:'),
          content: Text(respuesta['mensaje']['mensajeTraspaso']),
          actions: [
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamed(context,
                    '/farmarecepcion'); // Volver a la ruta "/traspasos"
              },
            ),
          ],
        ),
      );
    } else if (respuesta['respuesta'] == 'Error') {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Atención:'),
          content: Text(respuesta['mensaje']),
          actions: [
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamed(context,
                    '/traspasos-verificados'); // Volver a la ruta "/traspasos"
              },
            ),
          ],
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Atención:'),
          content: const Text(
              'Ha ocurrido un error al generar el kardex, intente nuevamente.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamed(context,
                    '/traspasos-verificados'); // Volver a la ruta "/traspasos"
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> argumentos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? traspaso = argumentos['traspaso'];

    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Traspaso',
              style: TextStyle(fontSize: 14)),
        ),
        body: Column(
          children: [
            Container(
              height: 60,
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: BarraBusqueda(
                  onFilter: (value) {
                    filterList(value);
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Productos $traspaso',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[600],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                //Antes de realizar la accion de generar Kardex muestra un dialogo de confirmacion
                                showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text('Atención:'),
                                    content: const Text(
                                        '¿Está seguro que desea generar el kardex?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('Aceptar'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          generarKardex();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    columnSpacing: 5,
                    columns: const [
                      DataColumn(
                        label: SizedBox(
                          width: 60,
                          child: Text(
                            'Cédula',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 80,
                          child: Text(
                            'Nombre',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Teléfono',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: listaFiltrada.map((articulosMemoria) {
                      final articulos = articulosMemoria;
                      return DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 60,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (articulos.barras.isEmpty)
                                      ? 'Sin código'
                                      : articulos.barras[0]['codigo']
                                          .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  articulos.descripcion.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              articulos.enteros.toString(),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                          DataCell(
                            Text(
                              articulos.sobrantes.toString(),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ),
                          DataCell(
                            Text(
                              articulos.faltantes.toString(),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  String elementoEncontrado = '';

                                  for (var i = 0;
                                      i < articulos.barras.length;
                                      i++) {
                                    if (articulos.barras[i]['codigo'] ==
                                        articulos.barras[i]['codigo']) {
                                      elementoEncontrado =
                                          articulos.barras[i]['codigo'];
                                      break;
                                    }
                                  }

                                  if (elementoEncontrado != null) {
                                    handleResta(elementoEncontrado);
                                  }
                                },
                                icon: const Icon(
                                    CupertinoIcons.minus_circle_fill,
                                    size: 40),
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  String elementoEncontrado = '';

                                  for (var i = 0;
                                      i < articulos.barras.length;
                                      i++) {
                                    if (articulos.barras[i]['codigo'] ==
                                        articulos.barras[i]['codigo']) {
                                      elementoEncontrado =
                                          articulos.barras[i]['codigo'];
                                      break;
                                    }
                                  }

                                  if (elementoEncontrado != null) {
                                    handleSuma(elementoEncontrado);
                                  }
                                },
                                icon: const Icon(
                                    CupertinoIcons.add_circled_solid,
                                    size: 40),
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () async {
                String codigoBarras = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666',
                  'Finalizar',
                  false,
                  ScanMode.BARCODE,
                );
                if (codigoBarras != '-1') {
                  handleResta(codigoBarras);
                }
              },
              tooltip: 'Scan',
              backgroundColor: Colors.red,
              heroTag: 'restar',
              child:
                  const Icon(Icons.barcode_reader), // Asigna un heroTag único
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              onPressed: () async {
                String codigoBarras = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666',
                  'Finalizar',
                  false,
                  ScanMode.BARCODE,
                );
                if (codigoBarras != '-1') {
                  handleSuma(codigoBarras);
                }
              },
              tooltip: 'Scan',
              backgroundColor: Colors.indigo, // Cambia el color a rojo
              heroTag: 'sumar',
              child:
                  const Icon(Icons.barcode_reader), // Asigna un heroTag único
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
