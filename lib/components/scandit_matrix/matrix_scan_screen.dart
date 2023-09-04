import 'package:farmaenlaceapp/components/scandit_matrix/scan_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class MatrixScanScreen extends StatefulWidget {
  final String licenseKey;

  const MatrixScanScreen(this.licenseKey, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      MatrixScanScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class MatrixScanScreenState extends State<MatrixScanScreen>
    with WidgetsBindingObserver
    implements BarcodeTrackingListener {
  final DataCaptureContext _context;
  final Camera? _camera = Camera.defaultCamera;
  late BarcodeTracking _barcodeTracking;
  late DataCaptureView _captureView;

  bool _isPermissionMessageVisible = false;
  List<ScanResult> scanResults = [];

  MatrixScanScreenState(this._context);

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) {
      setState(() {
        _isPermissionMessageVisible = !value;
        if (value) {
          _camera?.switchToDesiredState(FrameSourceState.on);
        }
      });
    });
  }

  void _initializeBarcodeTracking() {
    var cameraSettings = BarcodeTracking.recommendedCameraSettings;
    cameraSettings.preferredResolution = VideoResolution.fullHd;
    _camera?.applySettings(cameraSettings);

    var captureSettings = BarcodeTrackingSettings();
    captureSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.code39,
      Symbology.code128,
    });

    _barcodeTracking = BarcodeTracking.forContext(_context, captureSettings)
      ..addListener(this);

    _captureView = DataCaptureView.forContext(_context);
    _captureView.addOverlay(
        BarcodeTrackingBasicOverlay.withBarcodeTrackingForViewWithStyle(
            _barcodeTracking,
            _captureView,
            BarcodeTrackingBasicOverlayStyle.frame));

    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeTracking.isEnabled = true;
  }

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    _checkPermission();
    _initializeBarcodeTracking();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = PlatformText(
        'Active el permiso para acceder a cámara!',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    } else {
      var bottomPadding = 48 + MediaQuery.of(context).padding.bottom;
      var containerPadding = defaultTargetPlatform == TargetPlatform.iOS
          ? EdgeInsets.fromLTRB(48, 48, 48, bottomPadding)
          : const EdgeInsets.all(48);
      child = Stack(
        children: [
          _captureView,
          Container(
            alignment: Alignment.bottomCenter,
            padding: containerPadding,
            child: SizedBox(
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context, scanResults);
                },
                icon: const Icon(Icons.camera),
                color: Colors.white,
                iconSize: 74,
              ),
            ),
          ),
        ],
      );
    }
    return WillPopScope(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
            title:
                const Text('Escaner Scandit', style: TextStyle(fontSize: 14))),
        body: child,
      ),
      onWillPop: () {
        _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
        _camera?.switchToDesiredState(FrameSourceState.off);
        _barcodeTracking.removeListener(this);
        _barcodeTracking.isEnabled = false;
        return Future.value(true);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _camera?.switchToDesiredState(FrameSourceState.off);
    }
  }

  @override
  void didUpdateSession(
      BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    for (final trackedBarcode in session.addedTrackedBarcodes) {
      scanResults.add(ScanResult(
        trackedBarcode.barcode.symbology,
        trackedBarcode.barcode.data ?? '',
      ));
    }
  }

  T? _ambiguate<T>(T? value) => value;

  List<ScanResult> getScanResults() {
    return scanResults;
  }
}
