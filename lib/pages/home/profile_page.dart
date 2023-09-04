import 'package:farmaenlaceapp/components/app_bar.dart';
import 'package:farmaenlaceapp/components/side_menu.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: servicioLogin
          .datosUsuario(), // Llama al método para obtener los datos de usuario
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga el Future, puedes mostrar un indicador de carga
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si ocurre un error al cargar los datos, muestra un mensaje de error
          return const Text('Error al cargar los datos');
        } else {
          // Si los datos se cargan correctamente, construye la interfaz de usuario
          final datosUsuario = snapshot.data!; // Accede a los datos de usuario

          return Scaffold(
            appBar: const CustomAppBar(),
            drawer: const SideMenu(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('lib/assets/images/profile.jpeg'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    datosUsuario[6],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Usuario: ${datosUsuario[1]} (${datosUsuario[5]})', // Accede a los datos en cada línea de la lista
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dirección IP: ${datosUsuario[0]}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cerrar Sesión'),
                            content: const Text(
                                '¿Estás seguro de que quieres cerrar sesión?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context), // Cerrar el diálogo
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  servicioLogin.logoutUser();
                                  Navigator.pushNamed(context,
                                      '/'); // Cerrar el diálogo después de cerrar sesión
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
