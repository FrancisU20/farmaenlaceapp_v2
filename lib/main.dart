import 'package:farmaenlaceapp/providers/articulos_provider.dart';
import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/routes/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

import 'providers/servicio_farmastock.dart';

bool isLoggedIn = false;

Future<void> checkUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
}

Future<void> main() async {
  await dotenv.load();
  await checkUserLoggedIn();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(const FarmaEnlaceApp());
}

class FarmaEnlaceApp extends StatefulWidget {
  const FarmaEnlaceApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FarmaEnlaceAppState createState() => _FarmaEnlaceAppState();
}

class _FarmaEnlaceAppState extends State<FarmaEnlaceApp> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ServicioFarmastock()),
          ChangeNotifierProvider(create: (_) => ArticulosProvider()),
        ],
        child: MaterialApp(
          title: 'FarmaEnlace App',
          theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: Colors.indigo,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: isLoggedIn ? '/home' : '/',
          routes: routes,
        ));
  }
}
