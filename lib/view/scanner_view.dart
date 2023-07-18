import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../core/enum/scan_pay_type_enum.dart';
import '../core/painter/scanner_style_painter.dart';
import '../scan_pay_controller.dart';
import 'camera_view.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({
    super.key,
    required this.onSuccess,
    this.digitableBoletoPage,
    this.backgroundColor,
    required this.scanningType,
    required this.detectorPrimaryColor,
    required this.detectorSecudaryColor,
    this.headerText,
    this.titleButtonText,
    this.titleButtonTextStyle,
    this.secondaryColor,
    this.primaryColor,
    this.helpTextStyle,
  });
  final String? titleButtonText;

  final String? headerText;

  final Color? secondaryColor;

  final Color? primaryColor;

  final TextStyle? titleButtonTextStyle;

  final TextStyle? helpTextStyle;

  final Function(String) onSuccess;

  final Function()? digitableBoletoPage;

  final Color? backgroundColor;

  final ScanPayType scanningType;

  final Color? detectorPrimaryColor;
  final Color? detectorSecudaryColor;
  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  bool _canProcess = true;
  bool _isBusy = false;
  Widget? _detectorCode;

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  void initState() {
    _scanInit();
    _canProcess = true;
    super.initState();
  }

  void _scanInit() async {
    final List<CameraDescription> cameras = await availableCameras();
    fiancialScannerCameras = cameras;
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      scanPayType: widget.scanningType,
      helpText: widget.headerText,
      titleButtonText: widget.titleButtonText,
      titleButtonTextStyle: widget.titleButtonTextStyle,
      secondaryColor: widget.secondaryColor,
      primaryColor: widget.primaryColor,
      helpTextStyle: widget.helpTextStyle,
      detectorCode: _detectorCode ?? const Offstage(),
      colorBackground: widget.backgroundColor,
      onImage: (inputImage) => processImage(inputImage),
      accessInputField: widget.digitableBoletoPage,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    setState(() {
      _isBusy = true;
    });

    final List<Barcode> code = await _barcodeScanner.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = ScannerDetectorPainter(
        code: code,
        detectorPrimaryColor: widget.detectorPrimaryColor ?? Colors.white,
        detectorSecudaryColor: widget.detectorSecudaryColor ?? Colors.red,
      );
      _detectorCode = CustomPaint(painter: painter);

      if (_detectorCode != null && code.isNotEmpty) {
        _canProcess = false;
        widget.onSuccess(code.first.rawValue ?? '');
      }
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
