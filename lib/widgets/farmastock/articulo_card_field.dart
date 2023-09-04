import 'dart:async';

import 'package:farmaenlaceapp/providers/articulos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../models/farmastock/DTOs/ArticulosDTO.dart';

class ArticuloCardField extends StatefulWidget {
  final ArticuloDTO articuloDTO;
  const ArticuloCardField({
    super.key,
    required this.articuloDTO,
  });

  Future<String> scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cerrar',
        false,
        ScanMode.BARCODE,
      );
      return barcodeResult;
    } catch (e) {
      return "";
    }
  }

  @override
  State<ArticuloCardField> createState() => _ArticuloCardFieldState();
}

class _ArticuloCardFieldState extends State<ArticuloCardField> {
  // Controladores para los campos de texto
  TextEditingController cajasController = TextEditingController();
  TextEditingController fraccionController = TextEditingController();

  @override
  void dispose() {
    // Liberamos los recursos al salir del widget
    cajasController.dispose();
    fraccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //VARIABLES PARA TEXTOS
    final TextStyle textStylePrimary =
        TextStyle(fontWeight: FontWeight.bold, fontSize: size.height * 0.016);
    final TextStyle textStyleSecondary =
        TextStyle(fontSize: size.height * 0.014);
    //PROVIDERS
    final articuloProvider =
        Provider.of<ArticulosProvider>(context, listen: false);
    int cajas = 0;
    int fraccion = 0;

    //RETURN WIDGET
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.020),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.blue.shade900),
        borderRadius: BorderRadius.circular(12),
      ),
      child: !widget.articuloDTO.validado
          ? Container(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  _InfoArticulo(textStylePrimary, size, textStyleSecondary),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Control Inventario:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Form(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //TODO: DARLES TÍTULO A LOS CAMPOS DE CAJAS Y FRACCIONES
                          children: [
                            Container(
                              width: size.width * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: cajasController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Cajas',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 13.0),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.25,
                              decoration: BoxDecoration(
                                color: widget.articuloDTO.planArticulo
                                            .valorconversion >
                                        1
                                    ? Colors.black12
                                    : Colors.black26,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                enabled: widget.articuloDTO.planArticulo
                                            .valorconversion >
                                        1
                                    ? true
                                    : false,
                                keyboardType: TextInputType.number,
                                controller: fraccionController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Fracciones',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 13.0),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String barraCodigo = await widget.scanBarcode();

                                if (articuloProvider
                                    .exiteArticulo(barraCodigo)) {
                                  cajas++;
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14),
                              ),
                              child: Icon(
                                Icons.qr_code_scanner_sharp,
                                size: size.height * 0.020,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.articuloDTO.validado = true;
                                widget.articuloDTO.stockCaja =
                                    cajasController.text.isEmpty
                                        ? 0
                                        : int.parse(cajasController.text);
                                widget.articuloDTO.stockFraccion =
                                    fraccionController.text.isEmpty
                                        ? 0
                                        : int.parse(fraccionController.text);
                                //articuloProvider.guardarArticulo();
                                articuloProvider.contados++;
                                articuloProvider.pendientes--;
                                articuloProvider.notifyListeners();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade300,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14),
                              ),
                              child: Icon(
                                Icons.save_as_rounded,
                                size: size.height * 0.020,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  _InfoArticulo(textStylePrimary, size, textStyleSecondary),
                  Text(
                      "Cajas:  ${widget.articuloDTO.stockCaja} Fracciones: ${widget.articuloDTO.stockFraccion}"),
                ],
              ),
            ),
    );
  }

  //MÉTODO QUE PERMITE VISUALIZAR LA INFORMACIÓN DE UN ARTÍCULO
  Column _InfoArticulo(
      TextStyle textStylePrimary, Size size, TextStyle textStyleSecondary) {
    return Column(
      children: [
        Text(
          widget.articuloDTO.planArticulo.descripcion,
          style: textStylePrimary,
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: size.width * 0.06,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://farmaenlace.vtexassets.com/arquivos/ids/166768/0000101880.jpg?v=638116423759770000'),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Column(
                children: [
                  Text(
                    "Código Artículo:",
                    style: textStylePrimary,
                  ),
                  Text(
                    widget.articuloDTO.planArticulo.codigo,
                    style: textStyleSecondary,
                  ),
                  Text(
                    "Código de Barras:",
                    style: textStylePrimary,
                  ),
                  Text(
                    widget.articuloDTO.planArticulo.barra,
                    style: textStyleSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    );
  }
}
