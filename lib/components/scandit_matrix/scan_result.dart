import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class ScanResult {
  final Symbology symbology;
  final String data;

  ScanResult(this.symbology, this.data);
}
