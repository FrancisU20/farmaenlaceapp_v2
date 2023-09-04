import 'package:farmaenlaceapp/components/barra_busqueda.dart';
import 'package:farmaenlaceapp/providers/servicio_traspaso.dart';
import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/components/app_bar.dart';
import 'package:farmaenlaceapp/components/side_menu.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

final ServicioTraspaso servicioTraspaso = ServicioTraspaso();

class TraspasosTransito extends StatefulWidget {
  const TraspasosTransito({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TraspasosTransitoState createState() => _TraspasosTransitoState();
}

class _TraspasosTransitoState extends State<TraspasosTransito> {
  List<dynamic> datosGuia = [];
  List<dynamic> filteredData = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    cargarTraspasosTransito();
  }

  void cargarTraspasosTransito() async {
    List<dynamic> guias = await servicioTraspaso.traspasosTransito();
    setState(() {
      datosGuia = guias;
      filteredData = guias;
    });
  }

  void filterList(String value) {
    setState(() {
      filteredData = datosGuia.where((element) {
        return element['traspaso'].toString().contains(value);
      }).toList();
    });
  }

  Future<void> scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
          "#FF0000", "Cancel", true, ScanMode.BARCODE);
      filterList(barcodeResult);
    } catch (e) {
      setState(() {
        isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const SideMenu(),
      body: Column(
        children: [
          const Text(
            'Traspasos Sin Verificar',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: BarraBusqueda(
              onFilter: (value) {
                filterList(value);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            padding: const EdgeInsets.all(10),
            width: 250,
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius:
                  BorderRadius.circular(10), // Agregamos el borderRadius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.lightGreen,
                  ),
                  child: IconButton(
                    onPressed: () => scanBarcode(),
                    icon: const Icon(
                      Icons.barcode_reader,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 48, // Ancho del contenedor circular
                  height: 48, // Alto del contenedor circular
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigoAccent,
                  ),
                  child: IconButton(
                    onPressed: () => print('Guardar'),
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amberAccent,
                  ),
                  child: IconButton(
                    onPressed: () => print('Enviar'),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final datosGuia = filteredData[index];
                return buildGuiaItem(index, datosGuia, context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            scanBarcode();
          },
          backgroundColor: Colors.green,
          heroTag: 'verificar',
          child: const Icon(Icons.qr_code_scanner)),
      //Centrarlo en la parte media de la pantalla a la derecha
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildGuiaItem(int index, dynamic datosGuia, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar traspaso'),
              content: const Text(
                  '¿Está seguro de que desea verificar este traspaso?'),
              actions: [
                TextButton(
                    child: const Text('Sí'),
                    onPressed: () async {
                      await servicioTraspaso
                          .verificarTraspaso(datosGuia['traspaso']);
                    }),
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${datosGuia['traspaso']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${datosGuia['fecha']}\n${datosGuia['descripcion']}',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ])),
    );
  }
}
