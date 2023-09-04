import "package:flutter/material.dart";

class NoInfo extends StatelessWidget {
  final String url;
  final String mensajeVacio;
  const NoInfo({super.key, required this.url, required this.mensajeVacio});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
          ),
          Image(
            image: AssetImage(url),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mensajeVacio,
                style: TextStyle(fontSize: size.height * 0.020),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
