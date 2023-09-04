import 'package:farmaenlaceapp/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/theme/colors.dart';
import 'package:farmaenlaceapp/widgets/modulos_grid.dart';
import 'package:farmaenlaceapp/components/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String userName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                text: TextSpan(
                  text: "Hola,",
                  style: const TextStyle(color: kDarkBlue, fontSize: 20),
                  children: [
                    TextSpan(
                      text: userName, // Mostrar el nombre de usuario aquí
                      style: const TextStyle(
                          color: kDarkBlue, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: " selecciona un módulo:",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mis Módulos",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const ModulosGrid(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
