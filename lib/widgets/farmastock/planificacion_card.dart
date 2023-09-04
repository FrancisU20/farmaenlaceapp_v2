import 'package:flutter/material.dart';

class PlanificacionCard extends StatelessWidget {
  final int idPlan;

  final String numConteos;
  final String descripcion;
  final Function()? press;

  const PlanificacionCard(
      {super.key,
      required this.idPlan,
      required this.numConteos,
      required this.descripcion,
      this.press});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              offset: const Offset(0, 8),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ID: $idPlan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.018,
              ),
            ),
            Column(
              children: [
                Text(
                  descripcion,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.014),
                ),
                Text(
                  "Número de conteos: ${numConteos.toUpperCase() == 'N' ? 'Ninguno' : numConteos}",
                  style: TextStyle(fontSize: size.height * 0.013),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
