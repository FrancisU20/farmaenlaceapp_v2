import 'package:farmaenlaceapp/providers/servicio_login.dart';
import 'package:flutter/material.dart';

final ServicioLogin servicioLogin = ServicioLogin();

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: servicioLogin.datosUsuario(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey, size: 28),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          List<dynamic> datosUsuario = snapshot.data!;
          List<String> letters = datosUsuario[2].toString().split(" ");
          String fullName = datosUsuario[2];
          String farmacia = datosUsuario[6];
          String initials =
              letters.map((name) => name.isNotEmpty ? name[0] : '').join('');

          return AppBar(
            elevation: 0,
            backgroundColor: Colors.indigo,
            iconTheme: const IconThemeData(color: Colors.white, size: 28),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                child: PopupMenuButton(
                  offset: const Offset(0, kToolbarHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(Icons.person_outlined,
                                color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              fullName,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.store,
                              color: Colors
                                  .black, // Cambia el color del ícono aquí
                            ),
                            const SizedBox(width: 8),
                            Text(
                              farmacia,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
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
                                        onPressed: () => Navigator.pop(
                                            context), // Cerrar el diálogo
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
                            child: const Text(
                              'Cerrar Sesión',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      initials,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container(); // Handle the case when there's an error
        }
      },
    );
  }
}
