// ignore_for_file: prefer_const_constructors

import 'package:farmaenlaceapp/providers/articulos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar.dart';
import '../../components/side_menu.dart';

class VerificacionError extends StatelessWidget {
  const VerificacionError({super.key});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ArticulosProvider articulosProvider =
        Provider.of<ArticulosProvider>(context, listen: false);
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "RESULTADO INVENTARIO",
                style: TextStyle(
                    fontSize: size.height * 0.03, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.024),
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.blue.shade900),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Descuento: ${articulosProvider.descuento.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: size.height * 0.018,
                      ),
                    ),
                    Text(
                      "Aumento: ${articulosProvider.aumento.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: size.height * 0.018,
                      ),
                    ),
                    Text(
                      "Total: ${articulosProvider.total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: size.height * 0.018,
                      ),
                    ),
                  ],
                ),
              ),
              DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Entero')),
                  DataColumn(label: Text('Fraccion')),
                  DataColumn(label: Text('PVF')),
                  DataColumn(label: Text('Valor')),
                ],
                rows: articulosProvider.lstArticulosDTO.map((articulo) {
                  return DataRow(cells: [
                    DataCell(Text(articulo.planArticulo.descripcion)),
                    DataCell(
                      _InfromacionDataCell(
                        textInfo: articulo.stockCaja,
                      ),
                    ),
                    DataCell(
                      _InfromacionDataCell(
                        textInfo: articulo.stockFraccion,
                      ),
                    ),
                    DataCell(Text(articulo.planArticulo.pvf)),
                    DataCell(Text((((articulo.planArticulo.valorconversion *
                                    articulo.stockCaja) +
                                articulo.stockFraccion) *
                            double.parse(articulo.planArticulo.pvf))
                        .toStringAsFixed(2))),
                  ]);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InfromacionDataCell extends StatelessWidget {
  final int textInfo;
  const _InfromacionDataCell({
    super.key,
    required this.textInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: textInfo == 0
            ? Colors.white12
            : textInfo > 0
                ? Colors.orange.shade200
                : Colors.red.shade200,
      ),
      child: Center(
        child: Text(
          textInfo.toString(),
        ),
      ),
    );
  }
}
