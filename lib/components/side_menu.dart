import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ternav_icons/ternav_icons.dart';
import 'package:farmaenlaceapp/theme/colors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
                child: Image.asset(
              "lib/assets/images/farmaenlace.png",
            )),
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.home_2,
            title: "Inicio",
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.checklist,
            title: "FarmaStock",
            onTap: () {
              Navigator.pushNamed(context, '/planificacion');
            },
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.received,
            title: "Farmarecepción",
            onTap: () {
              Navigator.pushNamed(context, '/farmarecepcion');
            },
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.profile,
            title: "Perfil",
            onTap: () {
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          Container(
            height: 120,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: kLightBlue, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Problemas con la App?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Llamar a soporte",
                        style: TextStyle(color: kDarkBlue)),
                    IconButton(
                      onPressed: () {
                        const phoneNumber = '+593967831156';
                        FlutterPhoneDirectCaller.callNumber(phoneNumber);
                      },
                      icon: const Icon(
                        Icons.phone_android,
                        color: kDarkBlue,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      leading: Icon(
        icon,
        color: Colors.grey,
        size: 18,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
