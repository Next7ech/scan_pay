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
    required this.scanningType,
    required this.digitableBoletoPage,
    required this.maxDetectedCode,
    required this.minDetectedCode,
    required this.titleButtonText,
    required this.helpText,
    required this.titleButtonTextStyle,
    required this.helpTextStyle,
    required this.backgroundColor,
    required this.detectorPrimaryColor,
    required this.detectorSecondaryColor,
    required this.secondaryColor,
    required this.primaryColor,
  });
  final ScanPayType scanningType;

  final int maxDetectedCode;

  final int minDetectedCode;

  final String titleButtonText;

  final String helpText;

  final TextStyle titleButtonTextStyle;

  final TextStyle helpTextStyle;

  final Color backgroundColor;

  final Color detectorPrimaryColor;

  final Color detectorSecondaryColor;

  final Color secondaryColor;

  final Color primaryColor;

  final Function(String) onSuccess;

  final Function() digitableBoletoPage;

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
      helpText: widget.helpText,
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
        detectorPrimaryColor: widget.detectorPrimaryColor,
        detectorSecudaryColor: widget.detectorSecondaryColor,
        maxDetectedCode: widget.maxDetectedCode,
        minDetectedCode: widget.minDetectedCode,
      );
      _detectorCode = CustomPaint(painter: painter);

      if (widget.scanningType == ScanPayType.barcode &&
          code.isNotEmpty &&
          code.first.rawValue != null &&
          code.first.rawValue!.length >= widget.minDetectedCode &&
          code.first.rawValue!.length <= widget.maxDetectedCode) {
        _canProcess = false;
        _barcodeScanner.close();
        widget.onSuccess(code.first.rawValue ?? '');
      }
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
