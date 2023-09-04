import 'package:farmaenlaceapp/components/barra_busqueda.dart';
import 'package:farmaenlaceapp/providers/servicio_traspaso.dart';
import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/components/app_bar.dart';
import 'package:farmaenlaceapp/components/side_menu.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

final ServicioTraspaso servicioTraspaso = ServicioTraspaso();

class TraspasosRecepcion extends StatefulWidget {
  const TraspasosRecepcion({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TraspasosRecepcionState createState() => _TraspasosRecepcionState();
}

class _TraspasosRecepcionState extends State<TraspasosRecepcion> {
  List<dynamic> datosGuia = [];
  List<dynamic> filteredData = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    cargarTraspasosRecepcion();
  }

  void cargarTraspasosRecepcion() async {
    List<dynamic> guias = await servicioTraspaso.traspasosRecepcion();
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
            'Traspasos Por Recibir',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          BarraBusqueda(
            onFilter: (value) {
              filterList(value);
            },
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
    );
  }

  Widget buildGuiaItem(int index, dynamic datosGuia, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/traspasos-detalle',
            arguments: datosGuia);
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
